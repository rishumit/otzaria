import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:otzaria/theme/design_system.dart';

/// Adaptive dialog wrapper that shows Material dialogs on non-Windows platforms
/// and Fluent ContentDialog on Windows.
///
/// This provides a consistent API while adapting to the platform design language.
Future<T?> showOtzariaDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  if (useFluentDesign(context)) {
    return fluent.showDialog<T>(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
  }

  return showDialog<T>(
    context: context,
    builder: builder,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
  );
}

/// Adaptive AlertDialog/ContentDialog wrapper.
///
/// On Windows, renders as fluent.ContentDialog.
/// On other platforms, renders as Material AlertDialog.
class AdaptiveAlertDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? contentPadding;

  const AdaptiveAlertDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    if (useFluentDesign(context)) {
      return fluent.ContentDialog(
        title: title,
        content: content,
        actions: actions,
        style: fluent.ContentDialogThemeData(
          padding: contentPadding,
        ),
      );
    }

    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
      contentPadding: contentPadding,
    );
  }
}

/// Adaptive action button for dialogs.
///
/// On Windows, renders as fluent.Button (FilledButton for primary actions).
/// On other platforms, renders as Material TextButton/FilledButton.
class AdaptiveDialogAction extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const AdaptiveDialogAction({
    super.key,
    required this.child,
    this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    if (useFluentDesign(context)) {
      return isPrimary
          ? fluent.FilledButton(
              onPressed: onPressed,
              child: child,
            )
          : fluent.Button(
              onPressed: onPressed,
              child: child,
            );
    }

    return isPrimary
        ? FilledButton(
            onPressed: onPressed,
            child: child,
          )
        : TextButton(
            onPressed: onPressed,
            child: child,
          );
  }
}
