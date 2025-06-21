import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

int datecompare(DateTime? diff) {
  // calculates the number of months between a timestamp and current timestamp
  if (diff == null) {
    return 0;
  }
  final now = DateTime.now();
  final diffDuration = now.difference(diff);
  final diffInMonths = diffDuration.inDays ~/ 30;
  return 12 - diffInMonths;
}

int? dateleft(DateTime? daysleft) {
  // calculate 30 minus the number of days between a timestamp and current timestamp
  if (daysleft == null) {
    return null;
  }
  final now = DateTime.now();
  final difference = now.difference(daysleft).inDays;
  return 30 - difference;
}
