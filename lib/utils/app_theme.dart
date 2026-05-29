// lib/utils/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // ── Warna Utama Biru ─────────────────────────────────────────
  static const Color primary        = Color(0xFF1565C0); // biru tua
  static const Color primaryLight   = Color(0xFF1E88E5); // biru medium
  static const Color primaryLighter = Color(0xFF42A5F5); // biru terang
  static const Color primaryBg      = Color(0xFFE3F2FD); // biru sangat muda

  // ── Aksen ────────────────────────────────────────────────────
  static const Color accent         = Color(0xFFE53935); // merah (penting)
  static const Color accentGreen    = Color(0xFF43A047); // hijau (biasa/selesai)
  static const Color accentOrange   = Color(0xFFFB8C00); // orange (warning)

  // ── Netral ───────────────────────────────────────────────────
  static const Color background     = Color(0xFFF0F4FF); // biru sangat pucat
  static const Color surface        = Colors.white;
  static const Color textPrimary    = Color(0xFF0D1B2A);
  static const Color textSecondary  = Color(0xFF64748B);
  static const Color divider        = Color(0xFFE2E8F0);
  static const Color cardShadow     = Color(0x1A1565C0);

  // ── Gradient ─────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1E88E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          surface: surface,
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
            elevation: 2,
            shadowColor: primary.withOpacity(0.4),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primary, width: 2),
          ),
          labelStyle: const TextStyle(
            color: textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
        useMaterial3: true,
      );
}
