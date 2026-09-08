import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otzaria/theme/design_system.dart';

/// Adaptive text field that shows Material TextField on non-Windows platforms
/// and Fluent TextBox on Windows.
///
/// This wraps RtlTextField functionality with platform adaptation.
class OtTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final TextStyle? style;
  final InputDecoration? decoration;

  const OtTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.inputFormatters,
    this.readOnly = false,
    this.style,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    if (useFluentDesign) {
      return fluent.TextBox(
        controller: controller,
        placeholder: hintText ?? labelText,
        prefix: prefixIcon != null ? Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 4.0),
          child: prefixIcon,
        ) : null,
        suffix: suffixIcon != null ? Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 4.0),
          child: suffixIcon,
        ) : null,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        onTap: onTap,
        focusNode: focusNode,
        autofocus: autofocus,
        enabled: enabled,
        maxLines: maxLines,
        minLines: minLines,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        readOnly: readOnly,
        style: style,
        textDirection: TextDirection.rtl,
      );
    }

    return TextField(
      controller: controller,
      decoration: decoration ?? InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      focusNode: focusNode,
      autofocus: autofocus,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      style: style,
      textDirection: TextDirection.rtl,
    );
  }
}
