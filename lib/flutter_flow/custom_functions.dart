import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import '../../auth/auth_util.dart';

bool isStringArrayNullOrEmpty(List<String>? arr) {
  return arr == null || arr.isEmpty;
}

String convertStringToImagePath(String url) {
  return url;
}

String convertStringToVideoPath(String urlString) {
  return urlString;
}

List<String> mergeTwoStringArray(
  List<String> arrayA,
  List<String> arrayB,
) {
  return [...arrayA, ...arrayB].toSet().toList();
}
