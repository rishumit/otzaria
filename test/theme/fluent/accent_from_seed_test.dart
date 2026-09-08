import 'dart:math' show pow;

import 'package:flutter/material.dart' show Brightness, Color, Colors;
import 'package:flutter_test/flutter_test.dart';
import 'package:otzaria/theme/app_seed_colors.dart';
import 'package:otzaria/theme/fluent/accent_from_seed.dart';

void main() {
  // WCAG AA לטקסט רגיל: יחס ניגודיות >= 4.5:1
  const wcagAA = 4.5;

  group('accentFromSeed — WCAG AA contrast on normal swatch entry', () {
    for (final entry in AppSeedColors.options) {
      for (final brightness in [Brightness.light, Brightness.dark]) {
        final label = '${entry.name} / ${brightness.name}';

        test(label, () {
          final accent = accentFromSeed(entry.color, brightness);
          final normal = accent.normal;

          final onWhite = contrastRatio(normal, Colors.white);
          final onBlack = contrastRatio(normal, Colors.black);

          // לפחות אחד מהם חייב לעמוד ב-AA — טקסט על accent יהיה לבן או שחור
          expect(
            onWhite >= wcagAA || onBlack >= wcagAA,
            isTrue,
            reason: '$label: normal=#${normal.toARGB32().toRadixString(16)} '
                'onWhite=${onWhite.toStringAsFixed(2)}, '
                'onBlack=${onBlack.toStringAsFixed(2)} '
                '— neither meets WCAG AA ($wcagAA:1)',
          );
        });
      }
    }
  });

  group('accentFromSeed — swatch completeness', () {
    test('כל 7 מפתחות ה-swatch קיימים', () {
      final accent = accentFromSeed(AppSeedColors.blue, Brightness.light);
      for (final key in [
        'darkest',
        'darker',
        'dark',
        'normal',
        'light',
        'lighter',
        'lightest',
      ]) {
        expect(
          () => accent[key],
          returnsNormally,
          reason: 'missing swatch key: $key',
        );
      }
    });

    test('הגוונים בסדר עולה של בהירות (darkest → lightest)', () {
      final accent =
          accentFromSeed(AppSeedColors.darkBrown, Brightness.light);
      final keys = [
        'darkest',
        'darker',
        'dark',
        'normal',
        'light',
        'lighter',
        'lightest',
      ];
      final luminances = keys.map((k) => _luminance(accent[k]!)).toList();
      for (var i = 1; i < luminances.length; i++) {
        expect(
          luminances[i] >= luminances[i - 1],
          isTrue,
          reason: '${keys[i]} (${luminances[i].toStringAsFixed(3)}) '
              'אינו בהיר יותר מ-${keys[i - 1]} '
              '(${luminances[i - 1].toStringAsFixed(3)})',
        );
      }
    });

    test('seed לבן — מחזיר ניטרלי בלי חריג', () {
      expect(
        () => accentFromSeed(AppSeedColors.white, Brightness.light),
        returnsNormally,
      );
      expect(
        () => accentFromSeed(AppSeedColors.white, Brightness.dark),
        returnsNormally,
      );
    });

    test('seed אפור — מחזיר ניטרלי בלי חריג', () {
      expect(
        () => accentFromSeed(AppSeedColors.grey, Brightness.light),
        returnsNormally,
      );
    });
  });
}

/// מחשב luminance יחסית של צבע (0.0–1.0)
double _luminance(Color color) {
  double lin(double c) => c <= 0.04045
      ? c / 12.92
      : pow((c + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * lin(color.r) + 0.7152 * lin(color.g) + 0.0722 * lin(color.b);
}
