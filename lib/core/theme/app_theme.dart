import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF14B8A6); // Teal-500
  static const Color primaryForeground = Color(0xFFFFFFFF);
  static const Color secondaryColor = Color(0xFFF1F5F9);
  static const Color accentColor = Color(0xFF10B981); // Green-500 for accuracy/success
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color mutedColor = Color(0xFF64748B);
  static const Color mutedForegroundColor = Color(0xFF475569);
  static const Color successColor = Color(0xFF10B981); // Green-500 for good accuracy
  static const Color warningColor = Color(0xFFF59E0B); // Amber-500 for fair accuracy
  static const Color destructiveColor = Color(0xFFEF4444); // Red-500 for poor accuracy/errors

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        onPrimary: primaryForeground,
        secondary: secondaryColor,
        surface: cardColor,
        background: backgroundColor,
        error: destructiveColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderColor, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: mutedColor,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: primaryForeground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: mutedForegroundColor,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: mutedColor,
        ),
      ),
    );
  }

  static LinearGradient get primaryGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF0D9488), // Teal-600
        Color(0xFF14B8A6), // Teal-500
      ],
    );
  }

  static LinearGradient get heroGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF0D9488), // Teal-600
        Color(0xFF14B8A6), // Teal-500
        Color(0xFF10B981), // Green-500
      ],
    );
  }
}