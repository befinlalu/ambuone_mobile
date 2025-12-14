import 'package:ambuone_moblie/core/theme/index.dart';
import 'package:flutter/material.dart';

part 'primary_text_fields.dart';

class PrimaryTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final FormFieldValidator<String?>? validator;
  final String? hintText;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final int maxLine;
  final bool isBorderEnabled;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final TextInputType? keyBoardType;
  final bool? enabled;
  final int? maxLenth;
  final bool isSearchTrailing;
  final String? label;

  final bool isCounterText;
  const PrimaryTextFormField({
    this.enabled,
    this.keyBoardType,
    this.onChanged,
    this.onSubmit,
    this.controller,
    this.validator,
    this.hintText,
    this.prefixWidget,
    this.suffixWidget,
    this.isBorderEnabled = true,
    this.maxLine = 1,
    this.maxLenth,
    this.isSearchTrailing = false,
    this.isCounterText = false,
    this.label,
    super.key,
  });

  final _kBorderRadius = 16.0;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      enabled: enabled,
      keyboardType: keyBoardType,
      onChanged: onChanged,
      onFieldSubmitted: onSubmit,
      validator: validator,
      controller: controller,
      maxLines: maxLine,
      maxLength: maxLenth,
      style: AppFontStyles.bodySmall(context),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppFontStyles.bodySmallHint(context),
        counter: isCounterText ? null : const SizedBox.shrink(),
        counterStyle: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        alignLabelWithHint: true,
        prefixIcon: prefixWidget,
        suffixIcon: suffixWidget,
        prefixIconColor: Theme.of(context).colorScheme.onPrimary,
        filled: isBorderEnabled,
        fillColor: Colors.transparent,
        border: isBorderEnabled
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(_kBorderRadius),
                borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            : null,
        focusedBorder: isBorderEnabled
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(_kBorderRadius),
                borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            : null,
        enabledBorder: isBorderEnabled
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(_kBorderRadius),
                borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            : null,
      ),
    );
  }
}
