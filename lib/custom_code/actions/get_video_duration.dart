// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:video_player/video_player.dart';

Future<int> getVideoDuration(String videoUrl) async {
  // Initialize the VideoPlayerController
  VideoPlayerController controller = VideoPlayerController.network(videoUrl);

  // Initialize the controller
  await controller.initialize();

  // Get the video duration in seconds
  int durationInSeconds = controller.value.duration.inSeconds;

  // Dispose the controller after use
  controller.dispose();

  // Return the duration in seconds
  return durationInSeconds;
}
