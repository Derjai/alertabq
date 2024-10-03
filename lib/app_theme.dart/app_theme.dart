import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFFFFCB05), // Safety Yellow
      scaffoldBackgroundColor: const Color(0xFFFFFFFF), // White
      textTheme: _lightTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFFFFF), // White
        iconTheme: IconThemeData(color: Color(0xFF2D3748)), // Bold Charcoal
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFCB05), // Safety Yellow
          foregroundColor: const Color(0xFF2D3748), // Bold Charcoal
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF457B9D), // Steady Blue
          foregroundColor: const Color(0xFFFFFFFF), // White
          side:
              const BorderSide(color: Color(0xFFA8DADC), width: 2), // Aqua Haze
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color(0xFFA8DADC), // Aqua Haze
        selectionColor: Color(0xFFA8DADC), // Aqua Haze
        selectionHandleColor: Color(0xFFA8DADC), // Aqua Haze
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFFA8DADC), // Aqua Haze
      ),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
        iconColor: WidgetStateProperty.all(const Color(0xFFA8DADC)),
      )),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF457B9D), // Electric Blue
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFFFCB05), // Safety Yellow
        secondary: Color(0xFF457B9D), // Steady Blue
        onPrimary: Color(0xFF2D3748), // Bold Charcoal
        onSecondary: Color(0xFFFFFFFF), // White
        surface: Color(0xFFFFFFFF), // White
        error: Color(0xFFEF233C), // Crimson Alert
        onError: Color(0xFFFFFFFF), // White
        onSurface: Color(0xFF2D3748), // Bold Charcoal
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFFFFB703), // Safety Orange
      scaffoldBackgroundColor: const Color(0xFF1C1E21), // Night Black
      textTheme: _darkTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1C1E21), // Night Black
        iconTheme: IconThemeData(color: Color(0xFFF8F9FA)), // Off White
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFB703), // Safety Orange
          foregroundColor: const Color(0xFF1C1E21), // Night Black
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF3A86FF), // Electric Blue
          foregroundColor: const Color(0xFF1C1E21), // Night Black
          side: const BorderSide(
              color: Color(0xFF457B9D), width: 2), // Steady Blue
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color(0xFF457B9D), // Steady Blue
        selectionColor: Color(0xFF457B9D), // Steady Blue
        selectionHandleColor: Color(0xFF457B9D), // Steady Blue
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF457B9D), // Steady Blue
      ),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
        iconColor: WidgetStateProperty.all(const Color(0xFF457B9D)),
      )),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF3A86FF), // Electric Blue
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFFB703), // Safety Orange
        secondary: Color(0xFF3A86FF), // Electric Blue
        onPrimary: Color(0xFFF8F9FA), // Off White
        onSecondary: Color(0xFF1C1E21), // Night Black
        surface: Color(0xFF1C1E21), // Night Black
        error: Color(0xFFF72585), // Neon Pink Alert
        onError: Color(0xFFF8F9FA), // Off White
        onSurface: Color(0xFFF8F9FA), // Off White
      ),
    );
  }

  static final TextTheme _lightTextTheme =
      GoogleFonts.poppinsTextTheme().copyWith(
    bodyLarge: const TextStyle(color: Color(0xFF2D3748)), // Bold Charcoal
    bodyMedium: const TextStyle(color: Color(0xFF2D3748)),
    bodySmall: const TextStyle(color: Color(0xFF2D3748)), // Bold Charcoal
    displayLarge: const TextStyle(color: Color(0xFF2D3748)), // Bold Charcoal
    displayMedium: const TextStyle(color: Color(0xFF2D3748)), // Bold Charcoal
    displaySmall: const TextStyle(color: Color(0xFF2D3748)), // Bold Charcoal
    headlineLarge: const TextStyle(color: Color(0xFF2D3748)), // Bold Charcoal
    headlineMedium: const TextStyle(color: Color(0xFF2D3748)), // Bold Charcoal
    headlineSmall: const TextStyle(color: Color(0xFF2D3748)), // Bold Charcoal
    titleLarge: const TextStyle(color: Color(0xFF2D3748)), // Bold Charcoal
    titleMedium: const TextStyle(color: Color(0xFF2D3748)), // Bold Charcoal
    titleSmall: const TextStyle(color: Color(0xFF2D3748)), // Bold Charcoal
    labelLarge: const TextStyle(color: Color(0xFF2D3748)), // Bold Charcoal
    labelMedium: const TextStyle(color: Color(0xFF2D3748)), // Bold Charcoal
    labelSmall: const TextStyle(color: Color(0xFF2D3748)), // Bold Charcoal
  );

  static final TextTheme _darkTextTheme =
      GoogleFonts.poppinsTextTheme().copyWith(
    bodyLarge: const TextStyle(color: Color(0xFFF8F9FA)), // Off White
    bodyMedium: const TextStyle(color: Color(0xFFF8F9FA)),
    bodySmall: const TextStyle(color: Color(0xFFF8F9FA)), // Off White
    displayLarge: const TextStyle(color: Color(0xFFF8F9FA)), // Off White
    displayMedium: const TextStyle(color: Color(0xFFF8F9FA)), // Off White
    displaySmall: const TextStyle(color: Color(0xFFF8F9FA)), // Off White
    headlineLarge: const TextStyle(color: Color(0xFFF8F9FA)), // Off White
    headlineMedium: const TextStyle(color: Color(0xFFF8F9FA)), // Off White
    headlineSmall: const TextStyle(color: Color(0xFFF8F9FA)), // Off White
    titleLarge: const TextStyle(color: Color(0xFFF8F9FA)), // Off White
    titleMedium: const TextStyle(color: Color(0xFFF8F9FA)), // Off White
    titleSmall: const TextStyle(color: Color(0xFFF8F9FA)), // Off White
    labelLarge: const TextStyle(color: Color(0xFFF8F9FA)), // Off White
    labelMedium: const TextStyle(color: Color(0xFFF8F9FA)), // Off White
    labelSmall: const TextStyle(color: Color(0xFFF8F9FA)), // Off White
  );
}
