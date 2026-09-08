import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart' show ColorScheme, Brightness;
import 'package:otzaria/theme/fluent/accent_from_seed.dart';

/// Builds FluentThemeData from Material ColorScheme to maintain visual consistency
/// between Material (non-Windows) and Fluent (Windows) designs.
class FluentThemeBuilder {
  /// Creates a light Fluent theme from a Material ColorScheme.
  static fluent.FluentThemeData buildLightTheme(ColorScheme colorScheme) {
    final accentColor = accentFromSeed(
      colorScheme.primary,
      brightness: Brightness.light,
    );

    return fluent.FluentThemeData.light().copyWith(
      accentColor: accentColor,
      scaffoldBackgroundColor: colorScheme.surface,
      cardColor: colorScheme.surfaceContainerHigh,
      navigationPaneTheme: fluent.NavigationPaneThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        highlightColor: accentColor.lightest,
        selectedIconColor: fluent.ButtonState.resolveWith((states) {
          if (states.isDisabled) return colorScheme.onSurface.withValues(alpha: 0.38);
          if (states.isPressing) return accentColor.dark;
          if (states.isHovering) return accentColor.normal;
          return accentColor.normal;
        }),
        selectedTextStyle: fluent.ButtonState.resolveWith((states) {
          return fluent.TextStyle(
            color: states.isDisabled 
                ? colorScheme.onSurface.withValues(alpha: 0.38)
                : accentColor.normal,
            fontWeight: fluent.FontWeight.w600,
          );
        }),
        unselectedIconColor: fluent.ButtonState.resolveWith((states) {
          if (states.isDisabled) return colorScheme.onSurface.withValues(alpha: 0.38);
          if (states.isPressing) return colorScheme.onSurface.withValues(alpha: 0.87);
          if (states.isHovering) return colorScheme.onSurface.withValues(alpha: 0.87);
          return colorScheme.onSurfaceVariant;
        }),
      ),
      buttonTheme: fluent.ButtonThemeData(
        defaultButtonStyle: fluent.ButtonStyle(
          backgroundColor: fluent.ButtonState.resolveWith((states) {
            if (states.isDisabled) return colorScheme.onSurface.withValues(alpha: 0.12);
            if (states.isPressing) return colorScheme.surfaceContainerHighest;
            if (states.isHovering) return colorScheme.surfaceContainerHigh;
            return colorScheme.surfaceContainer;
          }),
          foregroundColor: fluent.ButtonState.resolveWith((states) {
            if (states.isDisabled) return colorScheme.onSurface.withValues(alpha: 0.38);
            return colorScheme.onSurface;
          }),
        ),
        filledButtonStyle: fluent.ButtonStyle(
          backgroundColor: fluent.ButtonState.resolveWith((states) {
            if (states.isDisabled) return colorScheme.onSurface.withValues(alpha: 0.12);
            if (states.isPressing) return accentColor.dark;
            if (states.isHovering) return accentColor.normal;
            return accentColor.normal;
          }),
          foregroundColor: fluent.ButtonState.resolveWith((states) {
            if (states.isDisabled) return colorScheme.onSurface.withValues(alpha: 0.38);
            return colorScheme.onPrimary;
          }),
        ),
      ),
      checkboxTheme: fluent.CheckboxThemeData(
        checkedDecoration: fluent.ButtonState.resolveWith((states) {
          return fluent.BoxDecoration(
            color: states.isDisabled 
                ? colorScheme.onSurface.withValues(alpha: 0.12)
                : accentColor.normal,
            borderRadius: fluent.BorderRadius.circular(4),
          );
        }),
        uncheckedDecoration: fluent.ButtonState.resolveWith((states) {
          return fluent.BoxDecoration(
            border: fluent.Border.all(
              color: states.isDisabled
                  ? colorScheme.onSurface.withValues(alpha: 0.38)
                  : colorScheme.outline,
              width: 1.5,
            ),
            borderRadius: fluent.BorderRadius.circular(4),
          );
        }),
      ),
      toggleSwitchTheme: fluent.ToggleSwitchThemeData(
        checkedTrackDecoration: fluent.ButtonState.resolveWith((states) {
          return fluent.BoxDecoration(
            color: states.isDisabled
                ? colorScheme.onSurface.withValues(alpha: 0.12)
                : accentColor.normal,
            borderRadius: fluent.BorderRadius.circular(12),
          );
        }),
        uncheckedThumbColor: fluent.ButtonState.all(colorScheme.outline),
        uncheckedTrackDecoration: fluent.ButtonState.resolveWith((states) {
          return fluent.BoxDecoration(
            color: states.isDisabled
                ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
                : colorScheme.surfaceContainerHighest,
            borderRadius: fluent.BorderRadius.circular(12),
          );
        }),
      ),
    );
  }

  /// Creates a dark Fluent theme from a Material ColorScheme.
  static fluent.FluentThemeData buildDarkTheme(ColorScheme colorScheme) {
    final accentColor = accentFromSeed(
      colorScheme.primary,
      brightness: Brightness.dark,
    );

    return fluent.FluentThemeData.dark().copyWith(
      accentColor: accentColor,
      scaffoldBackgroundColor: colorScheme.surface,
      cardColor: colorScheme.surfaceContainerHigh,
      navigationPaneTheme: fluent.NavigationPaneThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        highlightColor: accentColor.lightest.withValues(alpha: 0.2),
        selectedIconColor: fluent.ButtonState.resolveWith((states) {
          if (states.isDisabled) return colorScheme.onSurface.withValues(alpha: 0.38);
          if (states.isPressing) return accentColor.light;
          if (states.isHovering) return accentColor.lighter;
          return accentColor.lighter;
        }),
        selectedTextStyle: fluent.ButtonState.resolveWith((states) {
          return fluent.TextStyle(
            color: states.isDisabled
                ? colorScheme.onSurface.withValues(alpha: 0.38)
                : accentColor.lighter,
            fontWeight: fluent.FontWeight.w600,
          );
        }),
        unselectedIconColor: fluent.ButtonState.resolveWith((states) {
          if (states.isDisabled) return colorScheme.onSurface.withValues(alpha: 0.38);
          if (states.isPressing) return colorScheme.onSurface;
          if (states.isHovering) return colorScheme.onSurface;
          return colorScheme.onSurfaceVariant;
        }),
      ),
      buttonTheme: fluent.ButtonThemeData(
        defaultButtonStyle: fluent.ButtonStyle(
          backgroundColor: fluent.ButtonState.resolveWith((states) {
            if (states.isDisabled) return colorScheme.onSurface.withValues(alpha: 0.12);
            if (states.isPressing) return colorScheme.surfaceContainerHighest;
            if (states.isHovering) return colorScheme.surfaceContainerHigh;
            return colorScheme.surfaceContainer;
          }),
          foregroundColor: fluent.ButtonState.resolveWith((states) {
            if (states.isDisabled) return colorScheme.onSurface.withValues(alpha: 0.38);
            return colorScheme.onSurface;
          }),
        ),
        filledButtonStyle: fluent.ButtonStyle(
          backgroundColor: fluent.ButtonState.resolveWith((states) {
            if (states.isDisabled) return colorScheme.onSurface.withValues(alpha: 0.12);
            if (states.isPressing) return accentColor.light;
            if (states.isHovering) return accentColor.normal;
            return accentColor.normal;
          }),
          foregroundColor: fluent.ButtonState.resolveWith((states) {
            if (states.isDisabled) return colorScheme.onSurface.withValues(alpha: 0.38);
            return colorScheme.onPrimary;
          }),
        ),
      ),
      checkboxTheme: fluent.CheckboxThemeData(
        checkedDecoration: fluent.ButtonState.resolveWith((states) {
          return fluent.BoxDecoration(
            color: states.isDisabled
                ? colorScheme.onSurface.withValues(alpha: 0.12)
                : accentColor.normal,
            borderRadius: fluent.BorderRadius.circular(4),
          );
        }),
        uncheckedDecoration: fluent.ButtonState.resolveWith((states) {
          return fluent.BoxDecoration(
            border: fluent.Border.all(
              color: states.isDisabled
                  ? colorScheme.onSurface.withValues(alpha: 0.38)
                  : colorScheme.outline,
              width: 1.5,
            ),
            borderRadius: fluent.BorderRadius.circular(4),
          );
        }),
      ),
      toggleSwitchTheme: fluent.ToggleSwitchThemeData(
        checkedTrackDecoration: fluent.ButtonState.resolveWith((states) {
          return fluent.BoxDecoration(
            color: states.isDisabled
                ? colorScheme.onSurface.withValues(alpha: 0.12)
                : accentColor.normal,
            borderRadius: fluent.BorderRadius.circular(12),
          );
        }),
        uncheckedThumbColor: fluent.ButtonState.all(colorScheme.outline),
        uncheckedTrackDecoration: fluent.ButtonState.resolveWith((states) {
          return fluent.BoxDecoration(
            color: states.isDisabled
                ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                : colorScheme.surfaceContainerHighest,
            borderRadius: fluent.BorderRadius.circular(12),
          );
        }),
      ),
    );
  }
}
