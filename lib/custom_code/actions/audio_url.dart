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

/// Function to process and return a valid audio URL
Future<String> audioUrl(String audiopath) async {
  if (audiopath.isEmpty) {
    throw Exception('Invalid audio path.');
  }

  if (audiopath.startsWith('http') || audiopath.startsWith('https')) {
    return audiopath;
  }

  return 'https://yourstreamingserver.com/stream/$audiopath'; // Modify as needed
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
