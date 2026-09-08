import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:otzaria/utils/design_system.dart';

/// Adaptive checkbox that shows Material Checkbox on non-Windows platforms
/// and Fluent Checkbox on Windows.
class OtCheckbox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final bool tristate;

  const OtCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.tristate = false,
  });

  @override
  Widget build(BuildContext context) {
    if (useFluentDesign(context)) {
      return fluent.Checkbox(
        checked: value,
        onChanged: onChanged,
      );
    }

    return Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      checkColor: checkColor,
      tristate: tristate,
    );
  }
}

/// Adaptive CheckboxListTile that shows Material CheckboxListTile on non-Windows
/// and a custom Fluent equivalent on Windows.
class OtCheckboxListTile extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final Widget? secondary;
  final EdgeInsetsGeometry? contentPadding;
  final bool tristate;

  const OtCheckboxListTile({
    super.key,
    this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.secondary,
    this.contentPadding,
    this.tristate = false,
  });

  @override
  Widget build(BuildContext context) {
    if (useFluentDesign(context)) {
      return Padding(
        padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            fluent.Checkbox(
              checked: value,
              onChanged: onChanged,
            ),
            const SizedBox(width: 16),
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
          ],
        ),
      );
    }

    return CheckboxListTile(
      title: title,
      subtitle: subtitle,
      value: value,
      onChanged: onChanged,
      secondary: secondary,
      contentPadding: contentPadding,
      tristate: tristate,
    );
  }
}
