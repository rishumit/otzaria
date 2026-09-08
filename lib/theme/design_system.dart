import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// מקור האמת היחיד לשאלה "האם רצים ב-Fluent".
/// כל בדיקת פלטפורמה במיגרציה עוברת דרך כאן — אין Platform.isWindows מפוזר.
bool get useFluentDesign {
  if (kIsWeb) return false;
  if (!Platform.isWindows) return false;
  return _fluentEnabled;
}

// דגל build-time לכיבוי מהיר בלי rollback:
//   flutter run --dart-define=OTZARIA_FLUENT=false
const _fluentEnabled = bool.fromEnvironment(
  'OTZARIA_FLUENT',
  defaultValue: true,
);
