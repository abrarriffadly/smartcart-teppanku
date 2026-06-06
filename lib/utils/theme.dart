// lib/utils/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Warna utama Teppanku (dark red & amber dari mockup)
  static const Color primary = Color(0xFF8B1A1A);      // merah gelap
  static const Color primaryLight = Color(0xFFB71C1C);
  static const Color accent = Color(0xFFFFB300);        // amber/kuning
  static const Color background = Color(0xFFFFF8F0);    // krem hangat
  static const Color surface = Colors.white;
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textGrey = Color(0xFF757575);
  static const Color cardBg = Color(0xFFFFFBF7);
  static const Color success = Color(0xFF2E7D32);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: accent,
      surface: surface,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: cardBg,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),
  );
}
