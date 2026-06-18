import 'package:flutter/material.dart';

// ── Palette ──────────────────────────────────────────────────────────────────
const Color kBackground = Color(0xFFF5F5F0); // warm cream
const Color kSurface = Color(0xFFFFFFFF);    // white cards
const Color kAccent = Color(0xFF9EE64A);     // lime green
const Color kText = Color(0xFF1A1A1A);       // near-black
const Color kMuted = Color(0xFF6B7280);      // medium gray
const Color kBorder = Color(0xFFE8E8E3);     // subtle light border

// ── Geometry ──────────────────────────────────────────────────────────────────
const double kRadius = 20.0;
const double kRadiusSm = 12.0;
const double kRadiusPill = 50.0;

// ── Shadows ───────────────────────────────────────────────────────────────────
const List<BoxShadow> kCardShadow = [
  BoxShadow(
    color: Color(0x0F000000),
    blurRadius: 20,
    spreadRadius: 0,
    offset: Offset(0, 4),
  ),
];

// ── ThemeData ─────────────────────────────────────────────────────────────────
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: kBackground,
    colorScheme: const ColorScheme.light(
      primary: kText,
      secondary: kAccent,
      surface: kSurface,
      onPrimary: Colors.white,
      onSecondary: kText,
      onSurface: kText,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: kText, fontWeight: FontWeight.bold, letterSpacing: -0.5),
      headlineLarge: TextStyle(color: kText, fontWeight: FontWeight.bold, letterSpacing: -0.5),
      bodyLarge: TextStyle(color: kText),
      bodyMedium: TextStyle(color: kText),
      bodySmall: TextStyle(color: kMuted),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kText,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusPill)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kText,
        side: const BorderSide(color: kBorder, width: 1.5),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusPill)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kMuted,
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: kBackground,
      foregroundColor: kText,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: kText,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: kText),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadius),
        borderSide: const BorderSide(color: kBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadius),
        borderSide: const BorderSide(color: kBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadius),
        borderSide: const BorderSide(color: kText, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: const TextStyle(color: kBorder, fontSize: 14),
    ),
    dividerColor: kBorder,
    dividerTheme: const DividerThemeData(color: kBorder, thickness: 1),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: kText,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusSm)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
