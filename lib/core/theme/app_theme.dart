import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const ink = Color(0xFF172B2A);
  static const forest = Color(0xFF28645A);
  static const mint = Color(0xFFDDEDE5);
  static const sand = Color(0xFFF7F3EC);
  static const coral = Color(0xFFE87D61);

  static ThemeData _theme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: forest,
        brightness: brightness,
        surface: isDark ? const Color(0xFF172322) : sand,
      ),
      scaffoldBackgroundColor: isDark ? const Color(0xFF172322) : sand,
    );
    return base.copyWith(
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).apply(
        bodyColor: isDark ? Colors.white : ink,
        displayColor: isDark ? Colors.white : ink,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF172322) : sand,
        foregroundColor: isDark ? Colors.white : ink,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF172322) : sand,
        indicatorColor: isDark ? const Color(0xFF315B52) : mint,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF263836) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: forest, width: 1.4),
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF263836) : Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
    );
  }

  static ThemeData get light => _theme(Brightness.light);
  static ThemeData get dark => _theme(Brightness.dark);
}