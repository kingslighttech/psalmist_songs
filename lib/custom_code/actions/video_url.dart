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

/// Function to process and return a valid video URL
Future<String> videoUrl(String videopath) async {
  if (videopath.isEmpty) {
    throw Exception('Invalid video path.');
  }

  if (videopath.startsWith('http') || videopath.startsWith('https')) {
    return videopath;
  }

  return 'https://yourstreamingserver.com/stream/$videopath'; // Modify as needed
}
