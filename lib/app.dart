import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:otzaria/theme/design_system.dart';
import 'package:otzaria/theme/fluent/accent_from_seed.dart';
import 'package:otzaria/theme/fluent_theme_builder.dart';
import 'package:otzaria/theme/theme_exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otzaria/core/startup_timeline.dart';
import 'package:otzaria/core/ui_snack.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:otzaria/navigation/view/main_window_screen.dart';
import 'package:otzaria/settings/settings_exports.dart';
import 'package:otzaria/widgets/misc/middle_click_autoscroll.dart';
import 'package:window_manager/window_manager.dart';

// AppColors הועבר ל-lib/theme/app_colors.dart

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) {
        return previous.seedColor != current.seedColor ||
            previous.darkSeedColor != current.darkSeedColor ||
            previous.compactMenuMode != current.compactMenuMode ||
            previous.followSystemTheme != current.followSystemTheme ||
            previous.isDarkMode != current.isDarkMode;
      },
      builder: (context, settingsState) {
        StartupTimeline.instance.markOnce('appBuild');
        final state = settingsState;

        final lightColorScheme = AppThemeData.createColorScheme(
          state.seedColor,
          Brightness.light,
        );
        final darkColorScheme = AppThemeData.createColorScheme(
          state.darkSeedColor,
          Brightness.dark,
        );
        final materialTheme = AppThemeData.light(
          lightColorScheme,
          compactMenuMode: state.compactMenuMode,
        );
        final materialDarkTheme = AppThemeData.dark(
          darkColorScheme,
          compactMenuMode: state.compactMenuMode,
        );
        final useVirtualWindowFrame =
            !kIsWeb &&
            (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

        if (useFluentDesign) {
          return _buildFluentApp(
            state: state,
            materialTheme: materialTheme,
            materialDarkTheme: materialDarkTheme,
            useVirtualWindowFrame: useVirtualWindowFrame,
          );
        }

        return _buildMaterialApp(
          state: state,
          materialTheme: materialTheme,
          materialDarkTheme: materialDarkTheme,
          useVirtualWindowFrame: useVirtualWindowFrame,
        );
      },
    );
  }

  // ── Material (כל הפלטפורמות שאינן Windows Fluent) ──────────────────────
  Widget _buildMaterialApp({
    required SettingsState state,
    required ThemeData materialTheme,
    required ThemeData materialDarkTheme,
    required bool useVirtualWindowFrame,
  }) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('he', 'IL')],
      locale: const Locale('he', 'IL'),
      title: 'אוצריא',
      theme: materialTheme,
      darkTheme: materialDarkTheme,
      themeMode: state.followSystemTheme
          ? ThemeMode.system
          : (state.isDarkMode ? ThemeMode.dark : ThemeMode.light),
      builder: (context, child) =>
          _appBuilder(context, child, useVirtualWindowFrame),
      home: MainWindowScreen(key: mainWindowScreenKey),
    );
  }

  // ── Fluent (Windows בלבד) ───────────────────────────────────────────────
  //
  // עוטפים את FluentApp ב-Theme(data: materialTheme) כדי ש-FluentApp יאמץ
  // את ה-ThemeData הקיים דרך findAncestorWidgetOfExactType<m.Theme>().
  // כך כל 763 קריאות Theme.of(context) ממשיכות לעבוד ללא שינוי, ומסכים
  // שטרם הומרו נראים זהה לחלוטין.
  Widget _buildFluentApp({
    required SettingsState state,
    required ThemeData materialTheme,
    required ThemeData materialDarkTheme,
    required bool useVirtualWindowFrame,
  }) {
    final isDark = state.followSystemTheme
        ? (WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark)
        : state.isDarkMode;
    final activeTheme = isDark ? materialDarkTheme : materialTheme;
    final activeColorScheme = activeTheme.colorScheme;

    // Build Fluent theme from Material ColorScheme for full consistency
    final fluentTheme = isDark
        ? FluentThemeBuilder.buildDarkTheme(activeColorScheme)
        : FluentThemeBuilder.buildLightTheme(activeColorScheme);

    return Theme(
      data: activeTheme,
      child: fluent.FluentApp(
        navigatorKey: navigatorKey,
        localizationsDelegates: const [
          fluent.FluentLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('he', 'IL')],
        locale: const Locale('he', 'IL'),
        title: 'אוצריא',
        theme: fluentTheme,
        builder: (context, child) =>
            _appBuilder(context, child, useVirtualWindowFrame),
        home: MainWindowScreen(key: mainWindowScreenKey),
      ),
    );
  }

  // ── builder משותף — Material ו-Fluent ──────────────────────────────────
  Widget _appBuilder(
    BuildContext context,
    Widget? child,
    bool useVirtualWindowFrame,
  ) {
    Widget content = BlocSelector<SettingsBloc, SettingsState, String>(
      selector: (state) => state.settingsLanguageCode,
      builder: (context, languageCode) => SettingsTextScope(
        language: resolveSettingsLanguage(languageCode),
        child: child ?? const SizedBox.shrink(),
      ),
    );

    // קביעת צבע אייקוני פס הסטטוס לפי התמה הפעילה.
    // האפליקציה אינה משתמשת ב-AppBar רגיל, ולכן systemOverlayStyle
    // לא נקבע אוטומטית — מגדירים אותו כאן כדי שהשעה והאייקונים
    // יישארו נראים תמיד (בעיקר באנדרואיד במצב edge-to-edge).
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final overlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      );
      content = AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: content,
      );
    }

    // גלילה אוטומטית בלחיצת גלגל העכבר — עטיפה אחת לכל האפליקציה,
    // מתחת למסגרת החלון כדי שכפתורי המסגרת יישארו לחיצים.
    content = MiddleClickAutoScroll(child: content);

    if (!useVirtualWindowFrame) return content;

    return VirtualWindowFrame(child: content);
  }
}
