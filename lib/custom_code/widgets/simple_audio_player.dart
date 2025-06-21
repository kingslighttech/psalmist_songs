// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class SimpleAudioPlayer extends StatefulWidget {
  const SimpleAudioPlayer({
    Key? key,
    required this.audioUrl,
    this.width,
    this.height,
    this.loop = false, // Loop feature boolean
  }) : super(key: key);

  final String audioUrl;
  final double? width;
  final double? height;
  final bool loop;

  @override
  _SimpleAudioPlayerState createState() => _SimpleAudioPlayerState();
}

class _SimpleAudioPlayerState extends State<SimpleAudioPlayer> {
  late AudioPlayer _player;
  bool _isPlayerReady = false;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _player = AudioPlayer();
    await _player.setUrl(widget.audioUrl);
    if (widget.loop) {
      await _player.setLoopMode(LoopMode.one);
    } else {
      await _player.setLoopMode(LoopMode.off);
    }
    setState(() => _isPlayerReady = true);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 160,
      child: !_isPlayerReady
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final data = snapshot.data;
                final duration = data?.duration ?? Duration.zero;
                final position = data?.position ?? Duration.zero;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Duration texts wide apart above slider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatDuration(position),
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            formatDuration(duration),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    // Slider
                    Slider(
                      min: 0.0,
                      max: duration.inMilliseconds.toDouble(),
                      value: position.inMilliseconds
                          .clamp(0, duration.inMilliseconds)
                          .toDouble(),
                      onChanged: (value) {
                        _player.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                    const SizedBox(height: 16),
                    // Play / Pause button centered below
                    IconButton(
                      iconSize: 48,
                      icon: StreamBuilder<PlayerState>(
                        stream: _player.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final playing = playerState?.playing ?? false;

                          if (playing) {
                            return const Icon(Icons.pause_circle_filled);
                          } else {
                            return const Icon(Icons.play_circle_fill);
                          }
                        },
                      ),
                      onPressed: () {
                        if (_player.playing) {
                          _player.pause();
                        } else {
                          _player.play();
                        }
                      },
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
