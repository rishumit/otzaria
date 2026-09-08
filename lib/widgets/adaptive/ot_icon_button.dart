import 'package:flutter/material.dart' as m;
import 'package:fluent_ui/fluent_ui.dart' as f;
import 'package:otzaria/theme/design_system.dart';

/// Adapter ל-IconButton — Material ב-Android/iOS/Web/Linux/macOS,
/// Fluent ב-Windows כשמופעל useFluentDesign.
///
/// call sites לא צריכים לדעת על Fluent — פשוט מחליפים IconButton → OtIconButton.
class OtIconButton extends m.StatelessWidget {
  const OtIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.iconSize,
    this.color,
    this.style,
  });

  final m.Widget icon;
  final m.VoidCallback? onPressed;
  final String? tooltip;
  final double? iconSize;
  final m.Color? color;

  /// ButtonStyle (Material בלבד — מתעלם ב-Fluent)
  final m.ButtonStyle? style;

  @override
  m.Widget build(m.BuildContext context) {
    if (useFluentDesign) {
      final button = f.IconButton(
        icon: iconSize != null
            ? m.IconTheme(
                data: m.IconThemeData(size: iconSize, color: color),
                child: icon,
              )
            : color != null
            ? m.IconTheme(
                data: m.IconThemeData(color: color),
                child: icon,
              )
            : icon,
        onPressed: onPressed,
      );
      if (tooltip != null) {
        return f.Tooltip(message: tooltip!, child: button);
      }
      return button;
    }

    return m.IconButton(
      icon: icon,
      onPressed: onPressed,
      tooltip: tooltip,
      iconSize: iconSize,
      color: color,
      style: style,
    );
  }
}
