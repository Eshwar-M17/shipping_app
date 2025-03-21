import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors from Shiplee.ai
  static const Color primaryColor = Color(0xFF4D61FC); // Primary blue
  static const Color secondaryColor = Color(0xFF00D09C); // Accent green
  static const Color accentPink = Color(0xFFFF6B81); // Accent pink/red
  static const Color accentGreen = Color(
    0xFF00D09C,
  ); // Accent green same as secondary
  static const Color accentYellow = Color(0xFFFFAD32); // Accent yellow/orange

  // Background & Surface Colors
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color cardColor = Colors.white;
  static const Color dividerColor = Color(0xFFEAEDF2);

  // Text Colors
  static const Color textColor = Color(0xFF1E2432);
  static const Color secondaryTextColor = Color(0xFF6B7280);

  // Status Colors
  static const Color successColor = Color(0xFF00D09C);
  static const Color errorColor = Color(0xFFFF3B5E);
  static const Color warningColor = Color(0xFFFFAD32);
  static const Color infoColor = Color(0xFF38B6FF);

  // Metrics
  static const double borderRadius = 16.0;
  static const double smallBorderRadius = 8.0;
  static const double buttonHeight = 48.0;

  // Shadows
  static List<BoxShadow> boxShadow = [
    BoxShadow(
      color: Color.fromARGB(3, 0, 0, 0),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  // Text theme
  static TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.dmSans(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: textColor,
    ),
    displayMedium: GoogleFonts.dmSans(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: textColor,
    ),
    displaySmall: GoogleFonts.dmSans(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: textColor,
    ),
    headlineMedium: GoogleFonts.dmSans(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: textColor,
    ),
    headlineSmall: GoogleFonts.dmSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: textColor,
    ),
    labelLarge: GoogleFonts.dmSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: textColor,
    ),
    bodyLarge: GoogleFonts.dmSans(fontSize: 16, color: textColor),
    bodyMedium: GoogleFonts.dmSans(fontSize: 14, color: secondaryTextColor),
    bodySmall: GoogleFonts.dmSans(fontSize: 12, color: secondaryTextColor),
  );

  // Button themes
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(smallBorderRadius),
    ),
    textStyle: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600),
  );

  static ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: primaryColor,
    side: const BorderSide(color: primaryColor, width: 1.5),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(smallBorderRadius),
    ),
    textStyle: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600),
  );

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      background: backgroundColor,
      surface: cardColor,
    ),
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: cardColor,
      foregroundColor: textColor,
      centerTitle: false,
      titleTextStyle: textTheme.headlineSmall,
      iconTheme: const IconThemeData(color: primaryColor),
    ),
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: elevatedButtonStyle),
    outlinedButtonTheme: OutlinedButtonThemeData(style: outlinedButtonStyle),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
        borderSide: const BorderSide(color: dividerColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
        borderSide: const BorderSide(color: dividerColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
      labelStyle: textTheme.bodyMedium,
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: secondaryTextColor.withValues(
          alpha: (0.7 * 255).roundToDouble(),
          red: secondaryTextColor.red.toDouble(),
          green: secondaryTextColor.green.toDouble(),
          blue: secondaryTextColor.blue.toDouble(),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: cardColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: secondaryTextColor,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}
