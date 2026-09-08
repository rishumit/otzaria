import 'dart:math' show pow;

import 'package:flutter/material.dart' show Color, Colors, HSLColor, Brightness;
import 'package:fluent_ui/fluent_ui.dart' show AccentColor;

/// ממיר seed color שהמשתמש בחר ל-[AccentColor] של Fluent.
///
/// Fluent עובד עם swatch של 7 גוונים. כל הגוונים נגזרים מה-seed
/// בשינוי הבהירות (HSL lightness), תוך שמירה על גוון ורוויה זהים.
///
/// טיפול מיוחד ב-seed לבן (רוויה אפסית): מחזיר swatch אפור-ניטרלי
/// כי seed לבן נועד לממשק "נקי" ולא לצבע accent בולט.
AccentColor accentFromSeed(Color seed, Brightness brightness) {
  final hsl = HSLColor.fromColor(seed);

  // seed לבן/ניטרלי: רוויה אפסית — swatch אפור כהה שנראה טוב על לבן
  if (hsl.saturation < 0.05) {
    return _neutralAccent(brightness);
  }

  // מחשב lightness בסיס: במצב כהה מועלה מעט כדי שה-normal יהיה נראה
  final baseLightness = brightness == Brightness.dark
      ? (hsl.lightness < 0.5 ? 0.65 : hsl.lightness)
      : hsl.lightness;

  Color at(double delta) {
    final l = (baseLightness + delta).clamp(0.05, 0.95);
    return hsl.withLightness(l).toColor();
  }

  return AccentColor.swatch({
    'darkest': at(-0.30),
    'darker': at(-0.20),
    'dark': at(-0.10),
    'normal': at(0.0),
    'light': at(0.10),
    'lighter': at(0.20),
    'lightest': at(0.30),
  });
}

/// swatch ניטרלי לסידים לבנים/אפורים — צבע slate כהה שנראה טוב
/// על רקע לבן וגם על רקע כהה.
AccentColor _neutralAccent(Brightness brightness) {
  const base = Color(0xFF404040);
  final hsl = HSLColor.fromColor(base);

  Color at(double delta) {
    final l = (hsl.lightness + delta).clamp(0.05, 0.95);
    return hsl.withLightness(l).toColor();
  }

  return AccentColor.swatch({
    'darkest': at(-0.25),
    'darker': at(-0.15),
    'dark': at(-0.08),
    'normal': brightness == Brightness.dark ? at(0.30) : at(0.0),
    'light': at(0.15),
    'lighter': at(0.25),
    'lightest': at(0.35),
  });
}

/// מחשב יחס ניגודיות WCAG בין שני צבעים (1.0–21.0).
/// ערך >= 4.5 עומד בדרישת AA לטקסט רגיל.
double contrastRatio(Color foreground, Color background) {
  final fg = _relativeLuminance(foreground);
  final bg = _relativeLuminance(background);
  final lighter = fg > bg ? fg : bg;
  final darker = fg > bg ? bg : fg;
  return (lighter + 0.05) / (darker + 0.05);
}

double _relativeLuminance(Color color) {
  double linearize(double channel) {
    return channel <= 0.04045
        ? channel / 12.92
        : pow((channel + 0.055) / 1.055, 2.4).toDouble();
  }

  final r = linearize(color.r);
  final g = linearize(color.g);
  final b = linearize(color.b);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}
