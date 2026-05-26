// lib/theme/app_theme.dart — VestHub v0.0.3 Frutiger Aero

import 'package:flutter/material.dart';

class AppTheme {
  // ─── Fundo gradiente ──────────────────────────────────────────────────────
  static const Color bgTop    = Color(0xFF0A3D5C);
  static const Color bgMid    = Color(0xFF0B6E6E);
  static const Color bgBottom = Color(0xFF0D4F3C);

  // ─── Glass ────────────────────────────────────────────────────────────────
  static const Color glassWhite  = Color(0x1FFFFFFF); // 12% branco
  static const Color glassBorder = Color(0x47FFFFFF); // 28% branco
  static const Color glassShine  = Color(0x59FFFFFF); // 35% branco

  // ─── Status ───────────────────────────────────────────────────────────────
  static const Color greenGlass  = Color(0x2622C55E);
  static const Color greenBorder = Color(0x7222C55E);
  static const Color greenText   = Color(0xFF4ADE80);
  static const Color greenGlow   = Color(0x3322C55E);

  static const Color redGlass    = Color(0x26EF4444);
  static const Color redBorder   = Color(0x72EF4444);
  static const Color redText     = Color(0xFFF87171);
  static const Color redGlow     = Color(0x33EF4444);

  // ─── Texto ────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0x99FFFFFF); // 60%
  static const Color textMuted     = Color(0x66FFFFFF); // 40%
  static const Color textHint      = Color(0x40FFFFFF); // 25%

  // ─── Acento (botões, seleção) ─────────────────────────────────────────────
  static const Color accent        = Color(0xFF38BDF8); // azul céu
  static const Color accentGreen   = Color(0xFF4ADE80);
  static const Color accentRed     = Color(0xFFF87171);
  static const Color accentAmber   = Color(0xFFFBBF24);

  // Compat com código antigo
  static const Color bgDark      = bgTop;
  static const Color bgCard      = glassWhite;
  static const Color bgElevated  = Color(0x14FFFFFF);
  static const Color divider     = Color(0x1FFFFFFF);
  static const Color textHintOld = textHint;

  // ─── Gradientes ───────────────────────────────────────────────────────────
  static const LinearGradient bgGradient = LinearGradient(
    colors: [bgTop, bgMid, bgBottom],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF4ADE80), Color(0xFF22D3EE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0x26FFFFFF), Color(0x14FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Tema ─────────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgTop,
      colorScheme: const ColorScheme.dark(
        background: bgTop,
        surface: glassWhite,
        primary: accent,
        secondary: accentGreen,
        error: accentRed,
        onBackground: textPrimary,
        onSurface: textPrimary,
        onPrimary: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.3,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: textPrimary,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 10),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: glassWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: accent, width: 1.5),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textHint),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: const DividerThemeData(color: glassBorder, thickness: 0.5, space: 1),
      sliderTheme: const SliderThemeData(
        activeTrackColor: accent,
        inactiveTrackColor: glassWhite,
        thumbColor: accent,
        overlayColor: Color(0x2038BDF8),
        trackHeight: 4,
      ),
      cardTheme: CardThemeData(
        color: glassWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }

  // ─── Text styles ──────────────────────────────────────────────────────────
  static const TextStyle displayLarge = TextStyle(
    fontSize: 48, fontWeight: FontWeight.w500,
    color: textPrimary, letterSpacing: -2, height: 1.0,
  );
  static const TextStyle headingLarge = TextStyle(
    fontSize: 26, fontWeight: FontWeight.w500,
    color: textPrimary, letterSpacing: -0.5,
  );
  static const TextStyle headingMedium = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w500,
    color: textPrimary, letterSpacing: -0.3,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w400,
    color: textSecondary, height: 1.5,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: textMuted, height: 1.4,
  );
  static const TextStyle label = TextStyle(
    fontSize: 10, fontWeight: FontWeight.w600,
    color: textMuted, letterSpacing: 1.0,
  );
}
