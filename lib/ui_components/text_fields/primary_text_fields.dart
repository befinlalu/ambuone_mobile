part of 'index.dart';

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
  final TextInputType? keyboardType;
  final bool? enabled;
  final int? maxLenth;
  final bool isSearchTrailing;
  final String? label;
  final TextCapitalization textCapitalization;

  final bool isCounterText;
  const PrimaryTextFormField({
    this.enabled,
    this.keyboardType,
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
    this.textCapitalization = TextCapitalization.none,
    super.key,
  });

  final _kBorderRadius = 16.0;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      enabled: enabled,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onFieldSubmitted: onSubmit,
      validator: validator,
      controller: controller,
      maxLines: maxLine,
      maxLength: maxLenth,
      textCapitalization: textCapitalization,
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
        filled: enabled == false ? true : isBorderEnabled,
        fillColor: enabled == false ? Colors.grey.shade200 : Colors.transparent,
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
