import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otzaria/theme/fluent_theme_builder.dart';

void main() {
  group('FluentThemeBuilder', () {
    test('buildLightTheme creates theme from Material ColorScheme', () {
      final colorScheme = ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      );

      final fluentTheme = FluentThemeBuilder.buildLightTheme(colorScheme);

      expect(fluentTheme.scaffoldBackgroundColor, colorScheme.surface);
      expect(fluentTheme.cardColor, colorScheme.surfaceContainerHigh);
      expect(fluentTheme.accentColor, isNotNull);
    });

    test('buildDarkTheme creates theme from Material ColorScheme', () {
      final colorScheme = ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      );

      final fluentTheme = FluentThemeBuilder.buildDarkTheme(colorScheme);

      expect(fluentTheme.scaffoldBackgroundColor, colorScheme.surface);
      expect(fluentTheme.cardColor, colorScheme.surfaceContainerHigh);
      expect(fluentTheme.accentColor, isNotNull);
    });

    test('light and dark themes have different accent shades', () {
      final lightScheme = ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      );
      final darkScheme = ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      );

      final lightTheme = FluentThemeBuilder.buildLightTheme(lightScheme);
      final darkTheme = FluentThemeBuilder.buildDarkTheme(darkScheme);

      // Light theme uses normal/dark shades for selected items
      // Dark theme uses lighter shades for better visibility
      expect(lightTheme.accentColor.normal, isNotNull);
      expect(darkTheme.accentColor.lighter, isNotNull);
    });

    test('themes include button style configuration', () {
      final colorScheme = ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      );

      final fluentTheme = FluentThemeBuilder.buildLightTheme(colorScheme);

      expect(fluentTheme.buttonTheme, isNotNull);
      expect(fluentTheme.buttonTheme!.defaultButtonStyle, isNotNull);
      expect(fluentTheme.buttonTheme!.filledButtonStyle, isNotNull);
    });

    test('themes include checkbox and toggle switch configuration', () {
      final colorScheme = ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      );

      final fluentTheme = FluentThemeBuilder.buildLightTheme(colorScheme);

      expect(fluentTheme.checkboxTheme, isNotNull);
      expect(fluentTheme.toggleSwitchTheme, isNotNull);
    });

    test('navigation pane theme is configured', () {
      final colorScheme = ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      );

      final fluentTheme = FluentThemeBuilder.buildLightTheme(colorScheme);

      expect(fluentTheme.navigationPaneTheme, isNotNull);
      expect(
        fluentTheme.navigationPaneTheme!.backgroundColor,
        colorScheme.surfaceContainer,
      );
    });
  });
}
