import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Core Brand Colors (Romantic Love Theme) ───────────────────
  // Warm pinks, roses, and soft colors for love & good feelings
  static const Color primaryRed      = Color(0xFFE91E63); // romantic pink
  static const Color deepRed         = Color(0xFFD81B60); // deeper rose
  static const Color lightRed        = Color(0xFFFCE4EC); // soft pink tint
  static const Color accentWhite     = Color(0xFFFFFFFF);
  static const Color accentGray      = Color(0xFF9E9E9E);

  // ── Backgrounds (Light & Romantic) ───────────────────────────
  static const Color bgDark          = Color(0xFFFFF5F8); // soft pink-white
  static const Color bgCard          = Color(0xFFFFFFFF); // pure white
  static const Color bgSurface       = Color(0xFFFFF0F5); // lavender blush
  static const Color bgDeep          = Color(0xFFFCECF2); // very light pink

  // ── Text ─────────────────────────────────────────────────────
  static const Color textWhite       = Color(0xFFFFFFFF);  // For colored backgrounds
  static const Color textPrimary     = Color(0xFF2D2D2D);  // Main text on light bg
  static const Color textSecondary   = Color(0xFF5A5A5A);  // Secondary text
  static const Color textMuted       = Color(0xFF9E9E9E);  // Muted/placeholder text
  static const Color textDark        = Color(0xFF37474F);  // Dark headings
  static const Color divider         = Color(0xFFFFCDD2);  // Light pink divider

  // ── On-colors (for colored backgrounds) ─────────────────────
  static const Color onPrimary       = Color(0xFFFFFFFF);  // Text on primary color
  static const Color onCard          = Color(0xFF2D2D2D);  // Text on white cards

  // ── Gradients ─────────────────────────────────────────────────
  static const Color gradStart       = Color(0xFFE91E63);
  static const Color gradEnd         = Color(0xFFF48FB1);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradStart, gradEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [bgDeep, bgDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [bgCard, bgSurface],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFFFFEBEE), Color(0xFFFCE4EC), Color(0xFFF8BBD9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Theme Data ─────────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.light, // Changed to light for love feeling
    scaffoldBackgroundColor: bgDark,
    primaryColor: primaryRed,
    colorScheme: const ColorScheme.light(
      primary: primaryRed,
      secondary: deepRed,
      surface: bgCard,
    ),
    textTheme: GoogleFonts.dmSansTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: textDark, letterSpacing: -1),
        displayMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: textDark, letterSpacing: -0.5),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textDark),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textDark),
        bodyLarge: TextStyle(fontSize: 15, color: textDark),
        bodyMedium: TextStyle(fontSize: 13, color: textMuted),
        labelSmall: TextStyle(fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.w600, color: textMuted),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: textDark),
      titleTextStyle: TextStyle(color: textDark, fontSize: 18, fontWeight: FontWeight.w600),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: bgSurface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: divider)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: divider)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: primaryRed, width: 2)),
      hintStyle: const TextStyle(color: textMuted, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    ),
  );
}