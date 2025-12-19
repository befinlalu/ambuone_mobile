part of 'index.dart';

class OtpFields extends StatelessWidget {
  final int length;
  final ValueChanged<String>? onCompleted;
  final bool enabled;

  const OtpFields({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.enabled = true,
  });

  static const double _kBorderRadius = 8.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return PinCodeTextField(
      appContext: context,
      length: length,
      enabled: enabled,
      autoFocus: true,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      enableActiveFill: false,
      textStyle: AppFontStyles.h6(context),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(_kBorderRadius),
        fieldHeight: 52,
        fieldWidth: 48,

        inactiveColor: theme.secondary,
        selectedColor: theme.secondary,
        activeColor: theme.secondary,

        inactiveFillColor: Colors.transparent,
        selectedFillColor: Colors.transparent,
        activeFillColor: Colors.transparent,

        borderWidth: 1,
      ),
      cursorColor: theme.onPrimary,
      onChanged: (_) {},
      onCompleted: onCompleted,
    );
  }
}
