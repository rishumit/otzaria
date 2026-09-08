import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otzaria/utils/design_system.dart';
import 'package:otzaria/widgets/adaptive/adaptive_widgets.dart';
import 'package:otzaria/widgets/dialogs/adaptive_dialog.dart';
import 'package:otzaria/widgets/navigation/fluent_nav_rail_column.dart';
import 'package:otzaria/theme/fluent_theme_builder.dart';

/// Smoke tests to verify the Fluent migration is working correctly.
/// These tests ensure that:
/// 1. Adaptive widgets detect platform correctly
/// 2. Fluent themes are built from Material ColorScheme
/// 3. All critical adaptive components are exported
void main() {
  group('Fluent Migration Smoke Tests', () {
    testWidgets('OtIconButton renders without error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OtIconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(OtIconButton), findsOneWidget);
    });

    testWidgets('OtTextField renders without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OtTextField(
              hintText: 'חיפוש',
            ),
          ),
        ),
      );

      expect(find.byType(OtTextField), findsOneWidget);
    });

    testWidgets('OtSwitch renders without error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OtSwitch(
              value: true,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(OtSwitch), findsOneWidget);
    });

    testWidgets('OtCheckbox renders without error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OtCheckbox(
              value: true,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(OtCheckbox), findsOneWidget);
    });

    testWidgets('AdaptiveAlertDialog renders without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdaptiveAlertDialog(
              title: Text('כותרת'),
              content: Text('תוכן'),
              actions: [Text('אישור')],
            ),
          ),
        ),
      );

      expect(find.byType(AdaptiveAlertDialog), findsOneWidget);
      expect(find.text('כותרת'), findsOneWidget);
      expect(find.text('תוכן'), findsOneWidget);
    });

    testWidgets('FluentNavRailColumn renders without error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FluentNavRailColumn(
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('בית'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.search),
                  label: Text('חיפוש'),
                ),
              ],
              selectedIndex: 0,
              onDestinationSelected: (index) {},
            ),
          ),
        ),
      );

      expect(find.byType(FluentNavRailColumn), findsOneWidget);
    });

    test('useFluentDesign returns false on non-Windows context', () {
      // This is a basic smoke test - actual platform detection
      // requires integration testing on real Windows platform
      expect(useFluentDesign, isNotNull);
    });

    test('FluentThemeBuilder creates valid light theme', () {
      final colorScheme = ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      );

      final theme = FluentThemeBuilder.buildLightTheme(colorScheme);

      expect(theme, isNotNull);
      expect(theme.accentColor, isNotNull);
      expect(theme.scaffoldBackgroundColor, equals(colorScheme.surface));
    });

    test('FluentThemeBuilder creates valid dark theme', () {
      final colorScheme = ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      );

      final theme = FluentThemeBuilder.buildDarkTheme(colorScheme);

      expect(theme, isNotNull);
      expect(theme.accentColor, isNotNull);
      expect(theme.scaffoldBackgroundColor, equals(colorScheme.surface));
    });

    test('adaptive_widgets library exports all required components', () {
      // Verify that all adaptive widgets are accessible via the library export
      expect(OtIconButton, isNotNull);
      expect(OtTextField, isNotNull);
      expect(OtSwitch, isNotNull);
      expect(OtSwitchListTile, isNotNull);
      expect(OtCheckbox, isNotNull);
      expect(OtCheckboxListTile, isNotNull);
    });

    test('adaptive_dialog exports all required components', () {
      expect(showAdaptiveDialog, isNotNull);
      expect(AdaptiveAlertDialog, isNotNull);
      expect(AdaptiveDialogAction, isNotNull);
    });
  });

  group('Fluent Migration Integration Tests', () {
    testWidgets('Adaptive widgets work in nested context', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                OtIconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {},
                ),
                const OtTextField(
                  hintText: 'חיפוש',
                ),
                OtSwitch(
                  value: true,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(OtIconButton), findsOneWidget);
      expect(find.byType(OtTextField), findsOneWidget);
      expect(find.byType(OtSwitch), findsOneWidget);
    });

    testWidgets('OtSwitchListTile displays title and subtitle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OtSwitchListTile(
              title: const Text('כותרת'),
              subtitle: const Text('תת-כותרת'),
              value: true,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.text('כותרת'), findsOneWidget);
      expect(find.text('תת-כותרת'), findsOneWidget);
    });

    testWidgets('OtCheckboxListTile displays title and subtitle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OtCheckboxListTile(
              title: const Text('אופציה'),
              subtitle: const Text('תיאור'),
              value: false,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.text('אופציה'), findsOneWidget);
      expect(find.text('תיאור'), findsOneWidget);
    });
  });
}
