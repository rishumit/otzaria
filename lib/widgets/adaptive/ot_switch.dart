import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:otzaria/theme/design_system.dart';

/// Adaptive switch that shows Material Switch on non-Windows platforms
/// and Fluent ToggleSwitch on Windows.
class OtSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;

  const OtSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
  });

  @override
  Widget build(BuildContext context) {
    if (useFluentDesign) {
      return fluent.ToggleSwitch(
        checked: value,
        onChanged: onChanged,
      );
    }

    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      activeTrackColor: activeTrackColor,
      inactiveThumbColor: inactiveThumbColor,
      inactiveTrackColor: inactiveTrackColor,
    );
  }
}

/// Adaptive SwitchListTile that shows Material SwitchListTile on non-Windows
/// and a custom Fluent equivalent on Windows.
class OtSwitchListTile extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? secondary;
  final EdgeInsetsGeometry? contentPadding;

  const OtSwitchListTile({
    super.key,
    this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.secondary,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    if (useFluentDesign) {
      return Padding(
        padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            if (secondary != null) ...[
              secondary!,
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) DefaultTextStyle(
                    style: fluent.FluentTheme.of(context).typography.body ?? const TextStyle(),
                    child: title!,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    DefaultTextStyle(
                      style: fluent.FluentTheme.of(context).typography.caption ?? const TextStyle(),
                      child: subtitle!,
                    ),
                  ],
                ],
              ),
            ),
            fluent.ToggleSwitch(
              checked: value,
              onChanged: onChanged,
            ),
          ],
        ),
      );
    }

    return SwitchListTile(
      title: title,
      subtitle: subtitle,
      value: value,
      onChanged: onChanged,
      secondary: secondary,
      contentPadding: contentPadding,
    );
  }
}
