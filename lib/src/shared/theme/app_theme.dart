import 'package:flutter/material.dart';

/// Centralized theme management for the application.
class AppTheme {
  // Colors based on your provided design image.
  static const _darkBackground = Color(0xFF121212); // Deep anthracite gray
  static const _primaryRed = Color(0xFFE53935); // Vivid "Pinball" Red
  static const _surfaceGrey = Color(0xFF1E1E1E); // Gray for cards/surfaces

  /// Returns the global Dark Theme for the app.
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Roboto', // Clean, crisp, professional font
      scaffoldBackgroundColor: _darkBackground,

      colorScheme: const ColorScheme.dark(
        primary: _primaryRed,
        secondary: _primaryRed,
        surface: _surfaceGrey,
      ),

      // AppBar specific styling
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      // List styling
      listTileTheme: const ListTileThemeData(
        iconColor: _primaryRed,
        textColor: Colors.white,
      ),
    );
  }
}
