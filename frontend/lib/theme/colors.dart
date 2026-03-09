import 'package:flutter/material.dart';

// Kiddio primary design colors
const Color kPrimaryColor = Color(0xFF4A90E2); // Soft Blue
const Color kAccentColor = Color(0xFFFFD54F); // Soft Yellow

final ColorScheme kColorScheme = ColorScheme.fromSeed(
  seedColor: kPrimaryColor,
);

// Night Mode color scheme for late-night bookings
final ColorScheme kNightColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF212121), // Dark gray
  onPrimary: Color(0xFFFAFAFA),
  secondary: Color(0xFF607D8B), // Blue gray
  onSecondary: Color(0xFFFAFAFA),
  error: Color(0xFFCF6679),
  onError: Color(0xFFFAFAFA),
  background: Color(0xFF181818),
  onBackground: Color(0xFFFAFAFA),
  surface: Color(0xFF232323),
  onSurface: Color(0xFFFAFAFA),
);
