import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFFFFCB05), // Safety Yellow
      scaffoldBackgroundColor: const Color(0xFFFFFFFF), // White
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        bodyLarge: const TextStyle(color: Color(0xFF2D3748)), // Bold Charcoal
        bodyMedium: const TextStyle(color: Color(0xFF2D3748)), // Bold Charcoal
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFFFFF), // White
        iconTheme: IconThemeData(color: Color(0xFF2D3748)), // Bold Charcoal
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFCB05), // Safety Yellow
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF457B9D), // Steady Blue
        ),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFFA8DADC), // Aqua Haze
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFFFCB05), // Safety Yellow
        secondary: Color(0xFF457B9D), // Steady Blue
        error: Color(0xFFEF233C), // Crimson Alert
        onPrimary: Color(0xFFFFFFFF), // White (for text/icons on primary)
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFFFFB703), // Safety Orange
      scaffoldBackgroundColor: const Color(0xFF1C1E21), // Night Black
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        bodyLarge: const TextStyle(color: Color(0xFFF8F9FA)), // Off White
        bodyMedium: const TextStyle(color: Color(0xFFF8F9FA)), // Off White
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1C1E21), // Night Black
        iconTheme: IconThemeData(color: Color(0xFFF8F9FA)), // Off White
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFB703), // Safety Orange
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF3A86FF), // Electric Blue
        ),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF457B9D), // Steady Blue
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFFB703), // Safety Orange
        secondary: Color(0xFF3A86FF), // Electric Blue
        error: Color(0xFFF72585), // Neon Pink Alert
        onPrimary: Color(0xFF1C1E21), // Night Black (for text/icons on primary)
      ),
    );
  }
}
