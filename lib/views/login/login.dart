part of 'index.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController phoneController;
  String otpValue = '';
  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CommonAppbar(title: 'AmbuOne', isLeading: false, isLogo: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.35,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(AppImages.authLogo, fit: BoxFit.cover),
                  Container(
                    color: const Color.fromARGB(
                      255,
                      0,
                      0,
                      0,
                    ).withValues(alpha: 0.1),
                  ),
                ],
              ),
            ),

            // ⚪ Login Card
            Transform.translate(
              offset: const Offset(0, -40),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLoadingState) {
                      DialogManager.instance.showLoadingDialog(context);
                    }
                    if (state is GetOtpSuccessState) {
                      DialogManager.instance.hideLoadingDialog(context);
                    }
                    if (state is GetOtpErrorState) {
                      debugPrint(state.message);
                      DialogManager.instance.hideLoadingDialog(context);
                      ToastService.showError(state.message);
                    }
                    if (state is VerifyOtpErrorState) {
                      DialogManager.instance.hideLoadingDialog(context);
                      ToastService.showError(state.message);
                    }
                    if (state is VerifyOtpSuccessState) {
                      DialogManager.instance.hideLoadingDialog(context);
                      context.go(PageRoutes.home);
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: state is GetOtpSuccessState
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("LOGIN", style: AppFontStyles.h6(context)),
                                const SizedBox(height: 12),
                                Text(
                                  "OTP has been sent to your phone number ${state.phone}.",
                                  style: AppFontStyles.bodySmall(context),
                                ),
                                const SizedBox(height: 12),
                                OtpFields(
                                  length: 6,
                                  onCompleted: (otp) {
                                    debugPrint("Entered OTP: $otp");
                                    setState(() {
                                      otpValue = otp;
                                    });
                                  },
                                ),
                                MainButton(
                                  buttonColor: AppColors.redColor,
                                  buttonTitle: 'Login',
                                  textStyle: TextStyle(color: Colors.white),
                                  onPressed: verifyOtp(),
                                ),
                              ],
                            )
                          : LoginSection(
                              controller: phoneController,
                              onPressed: getOtp,
                            ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  verifyOtp() {
    if (otpValue.length < 6) {
      ToastService.showError('Invalid OTP');
      return;
    }
  }

  getOtp() {
    if (_formKey.currentState!.validate()) {
      if (phoneController.text.length < 10) {
        ToastService.showError('Invalid phone number');
        return;
      }
      context.read<AuthBloc>().add(
        GetLoginOtpEvent(phoneNumber: phoneController.text),
      );
    }
  }
}
