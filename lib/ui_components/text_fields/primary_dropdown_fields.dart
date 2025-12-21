part of 'index.dart';

class PrimaryDropdownFields<T> extends StatelessWidget {
  final T? initialValue;
  final List<DropdownMenuItem<T>> items;
  final Function(T?)? onChanged;
  final String? label;
  final String? hintText;
  final Widget? prefixWidget;
  final FormFieldValidator<T>? validator;
  final bool isBorderEnabled;
  final bool enabled;

  const PrimaryDropdownFields({
    required this.items,
    this.onChanged,
    this.initialValue,
    this.label,
    this.hintText,
    this.prefixWidget,
    this.validator,
    this.isBorderEnabled = true,
    this.enabled = true,
    super.key,
  });

  final _kBorderRadius = 16.0;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: initialValue,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,

      // Matches your TextFormField style
      style: AppFontStyles.bodySmall(context),
      icon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppFontStyles.bodySmallHint(context),
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        prefixIcon: prefixWidget,
        prefixIconColor: Theme.of(context).colorScheme.onPrimary,
        filled: isBorderEnabled,
        fillColor: Colors.transparent,
        // Replicating your specific border logic
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
      dropdownColor: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(_kBorderRadius),
      menuMaxHeight: 300,
    );
  }
}
