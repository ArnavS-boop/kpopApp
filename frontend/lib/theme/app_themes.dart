
import 'package:flutter/material.dart';

final ThemeData dark = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.transparent,

  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF4E2AFF), // 💜 purple accent
    onSurface: Colors.white,
  ),
);
