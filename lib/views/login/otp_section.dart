part of 'index.dart';

class OtpSection extends StatefulWidget {
  final String phone;
  final VoidCallback onChangePhone;

  const OtpSection({
    super.key,
    required this.phone,
    required this.onChangePhone,
  });

  @override
  State<OtpSection> createState() => _OtpSectionState();
}

class _OtpSectionState extends State<OtpSection> {
  String otp = '';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('LOGIN', style: AppFontStyles.h6(context)),
        const SizedBox(height: 12),

        Text.rich(
          TextSpan(
            text: 'Enter the OTP sent to your phone number - ',
            style: AppFontStyles.bodySmall(context),
            children: [
              TextSpan(
                text: widget.phone,
                style: AppFontStyles.bodySmallBold(context),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        GestureDetector(
          onTap: widget.onChangePhone,
          child: Text(
            'Change phone number',
            style: AppFontStyles.bodySmall(context).copyWith(
              color: colorScheme.tertiary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),

        const SizedBox(height: 16),

        OtpFields(
          length: 6,
          onCompleted: (value) {
            otp = value;
          },
        ),

        const SizedBox(height: 20),

        MainButton(
          buttonColor: AppColors.redColor,
          buttonTitle: 'Login',
          textStyle: const TextStyle(color: Colors.white),
          onPressed: () => verifyOtp(widget.phone, otp),
        ),
      ],
    );
  }

  void verifyOtp(String phoneNumber, String otp) {
    if (otp.length < 6) {
      ToastService.showError('Invalid OTP');
      return;
    }

    context.read<AuthBloc>().add(
      VerifyLoginOtpEvent(phoneNumber: phoneNumber, otp: otp),
    );
  }
}
