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

Future<String> convertImagePathToUrl(String imagepath) async {
  if (imagepath.isEmpty) {
    throw Exception('Invalid image path.');
  }

  if (imagepath.startsWith('http') || imagepath.startsWith('https')) {
    return imagepath;
  }

  return 'https://yourstreamingserver.com/stream/$imagepath'; // Modify as needed
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
