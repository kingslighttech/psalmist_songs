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

import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({
    super.key,
    this.width,
    this.height,
    required this.videoUrl,
    required this.autoPlay,
    required this.loop,
  });

  final double? width;
  final double? height;
  final String videoUrl;
  final bool autoPlay;
  final bool loop;

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isVideoStarted = false;
  bool _hasReachedOneMinute = false;
  bool _hasReachedTwoMinutes = false;
  double _seekValue = 0; // Track seek position

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
        _handleVideoStart();
        _checkTimeMarks();
        _checkIfVideoEnded();
        setState(() {}); // Update UI
      })
      ..initialize().then((_) {
        if (widget.autoPlay) {
          _controller.play();
          WakelockPlus.enable();
          setState(() {
            FFAppState().isVideoPlaying = true;
          });
        }
        if (widget.loop) {
          _controller.setLooping(true);
        }
        setState(() {});
      });
  }

  void _handleVideoStart() {
    if (!_isVideoStarted && _controller.value.isPlaying) {
      _isVideoStarted = true;
      setState(() {
        FFAppState().videoProgress = 0;
        FFAppState().videoProgress = 0; // ✅ Reset FFPageState when video starts
        FFAppState().isVideoPlaying = true;
      });
      WakelockPlus.enable();
    }
  }

  void _checkTimeMarks() {
    final currentPosition = _controller.value.position.inSeconds;

    if (!_hasReachedOneMinute && currentPosition >= 60) {
      _hasReachedOneMinute = true;
      setState(() {
        FFAppState().videoProgress = 60; // ✅ Update at 1 min
      });
    } else if (_hasReachedOneMinute && currentPosition < 60) {
      _hasReachedOneMinute = false; // Reset if seeking backward
    }

    if (!_hasReachedTwoMinutes && currentPosition >= 120) {
      _hasReachedTwoMinutes = true;
      setState(() {
        FFAppState().videoProgress = 120; // ✅ Update at 2 min
      });
    } else if (_hasReachedTwoMinutes && currentPosition < 120) {
      _hasReachedTwoMinutes = false; // Reset if seeking backward
    }
  }

  void _checkIfVideoEnded() {
    if (_controller.value.position >= _controller.value.duration) {
      if (widget.loop) {
        _controller.seekTo(Duration.zero);
        _controller.play();
        setState(() {
          FFAppState().videoProgress = 0; // ✅ Reset FFPageState on repeat
        });
      } else {
        setState(() {
          FFAppState().videoProgress = _controller.value.duration.inSeconds;
          FFAppState().isVideoPlaying = false;
        });
        WakelockPlus.disable();
      }
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        WakelockPlus.disable();
        FFAppState().isVideoPlaying = false;
      } else {
        _controller.play();
        WakelockPlus.enable();
        FFAppState().isVideoPlaying = true;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_controller.value.isInitialized)
          GestureDetector(
            onDoubleTap: _enterFullScreen,
            child: Container(
              width: widget.width,
              height: widget.height,
              child: VideoPlayer(_controller),
            ),
          )
        else
          SizedBox(
            width: widget.width,
            height: widget.height,
            child: const Center(child: CircularProgressIndicator()),
          ),
        if (_controller.value.isInitialized)
          Column(
            children: [
              Slider(
                value: _seekValue > 0
                    ? _seekValue
                    : _controller.value.position.inSeconds.toDouble(),
                max: _controller.value.duration.inSeconds.toDouble(),
                min: 0,
                onChangeStart: (value) {
                  setState(() {
                    _seekValue = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    _seekValue = value;
                  });
                },
                onChangeEnd: (value) {
                  final wasPlaying = _controller.value.isPlaying;
                  _controller
                      .seekTo(Duration(seconds: value.toInt()))
                      .then((_) {
                    if (wasPlaying) _controller.play();
                  });
                  setState(() {
                    _seekValue = 0;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(_controller.value.position)),
                    Text(_formatDuration(_controller.value.duration)),
                  ],
                ),
              ),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 48),
            IconButton(
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: _togglePlayPause,
            ),
            IconButton(
              icon: const Icon(Icons.fullscreen),
              onPressed: _enterFullScreen,
            ),
          ],
        ),
      ],
    );
  }

  void _enterFullScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(controller: _controller),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({Key? key, required this.controller})
      : super(key: key);

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: widget.controller.value.aspectRatio,
              child: VideoPlayer(widget.controller),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.black,
        ),
        onPressed: () {
          setState(() {
            widget.controller.value.isPlaying
                ? widget.controller.pause()
                : widget.controller.play();
          });
        },
      ),
    );
  }
}
