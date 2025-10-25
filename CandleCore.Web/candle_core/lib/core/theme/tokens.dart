import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  // Primary brand
  static const primary = Color(0xFF00C36A); // vibrant green
  static const primaryLight = Color(0xFF22C55E);
  static const primaryDark = Color(0xFF15803D);
  static const primaryForeground = Color(0xFFFFFFFF);

  // Backgrounds
  static const backgroundLight = Color(0xFFFFFFFF);
  static const backgroundDark = Color(0xFF252525); // oklch(0.145 0 0)

  // Text
  static const textPrimary = Color(0xFF030213);
  static const textSecondary = Color(0xFF717182);
  static const textLight = Color(0xFFFBFBFB); // oklch(0.985 0 0)

  // Surfaces & cards
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF252525);
  static const cardLight = Color(0xFFFFFFFF);
  static const cardDark = Color(0xFF252525);

  // Secondary surfaces
  static const secondaryLight = Color(0xFFF3F3F5); // approximated from oklch
  static const secondaryDark = Color(0xFF444444); // oklch(0.269 0 0)

  // Muted colors
  static const mutedLight = Color(0xFFECECF0);
  static const mutedDark = Color(0xFF444444);
  static const mutedForegroundLight = Color(0xFF717182);
  static const mutedForegroundDark = Color(0xFFB5B5B5); // oklch(0.708 0 0)

  // Accent colors
  static const accentLight = Color(0xFFE9EBEF);
  static const accentDark = Color(0xFF444444);

  // Input backgrounds
  static const inputBackgroundLight = Color(0xFFF3F3F5);
  static const inputBackgroundDark = Color(0xFF444444);

  // Switch background
  static const switchBackground = Color(0xFFCBCED4);

  // Borders
  static const borderLight = Color(0x1A000000); // rgba(0, 0, 0, 0.1)
  static const borderDark = Color(0xFF444444);

  // Error/Destructive
  static const error = Color(0xFFD4183D);
  static const errorForeground = Color(0xFFFFFFFF);

  // Success
  static const success = Color(0xFF00C36A); // using your primary green
  static const successForeground = Color(0xFFFFFFFF);

  // Chart colors
  static const chart1 = Color(0xFFE74C3C); // approximated from oklch
  static const chart2 = Color(0xFF3498DB);
  static const chart3 = Color(0xFF2ECC71);
  static const chart4 = Color(0xFFF39C12);
  static const chart5 = Color(0xFF9B59B6);

  // Ring/Focus colors
  static const ringLight = Color(0xFFB5B5B5);
  static const ringDark = Color(0xFF717171);
}

/// 🧱 Spacing Tokens
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

/// 🟩 Border Radius Tokens  
class AppRadii {
  static const sm = 6.0;  // --radius-sm: calc(var(--radius) - 4px)
  static const md = 8.0;  // --radius-md: calc(var(--radius) - 2px)
  static const lg = 10.0; // --radius-lg: var(--radius) = 0.625rem
  static const xl = 14.0; // --radius-xl: calc(var(--radius) + 4px)
}

/// 📏 Typography Design Tokens
/// Consistent font weights, sizes, and spacing throughout the app.
class AppTypography {
  // 🔤 Font weights
  static const fontWeightThin = FontWeight.w100;
  static const fontWeightExtraLight = FontWeight.w200;
  static const fontWeightLight = FontWeight.w300;
  static const fontWeightNormal = FontWeight.w400;
  static const fontWeightMedium = FontWeight.w500;
  static const fontWeightSemiBold = FontWeight.w600;
  static const fontWeightBold = FontWeight.w700;
  static const fontWeightExtraBold = FontWeight.w800;
  static const fontWeightBlack = FontWeight.w900;

  // 🔠 Font sizes (logical pixels)
  static const textXs = 12.0;     // caption / helper text
  static const textSm = 14.0;     // small text
  static const textBase = 16.0;   // normal body
  static const textLg = 18.0;     // large body / subtitle
  static const textXl = 20.0;     // h6
  static const text2xl = 24.0;    // h5
  static const text3xl = 30.0;    // h4
  static const text4xl = 36.0;    // h3
  static const text5xl = 48.0;    // h2
  static const text6xl = 60.0;    // h1

  // 🧱 Letter spacing
  static const letterSpacingTight = -0.5;
  static const letterSpacingNormal = 0.0;
  static const letterSpacingWide = 0.5;

  // 🧩 Line height multipliers
  static const lineHeightTight = 1.1;
  static const lineHeightNormal = 1.4;
  static const lineHeightRelaxed = 1.6;
}
