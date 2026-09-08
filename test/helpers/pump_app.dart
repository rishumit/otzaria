import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// עוטף widget תחת אפליקציה מינימלית לטסטים.
///
/// כרגע תמיד מחזיר MaterialApp — כשהמיגרציה מגיעה למסך מסוים ומעדכנים
/// את הטסטים שלו, מעבירים [fluent: true] כדי להריץ תחת FluentApp.
/// טסטים של מסכים שטרם הומרו נשארים על [fluent: false] (ברירת מחדל)
/// וממשיכים לעבור ללא שינוי.
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  bool fluent = false,
  ThemeData? theme,
}) async {
  // fluent=true ישמש כשנוסיף FluentApp — כרגע ה-Spike עדיין בפיתוח
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('he', 'IL')],
      locale: const Locale('he', 'IL'),
      theme: theme,
      home: Scaffold(body: child),
    ),
  );
}
