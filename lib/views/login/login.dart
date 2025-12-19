part of 'index.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController phoneController;

  bool showOtpSection = false;

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
            // 🔵 Top Image Section
            SizedBox(
              height: size.height * 0.35,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(AppImages.authLogo, fit: BoxFit.cover),
                  Container(color: Colors.black.withOpacity(0.1)),
                ],
              ),
            ),

            // ⚪ Card Section
            Transform.translate(
              offset: const Offset(0, -40),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLoadingState) {
                      DialogManager.instance.showLoadingDialog(context);
                    }

                    if (state is GetOtpSuccessState) {
                      DialogManager.instance.hideLoadingDialog(context);
                      setState(() {
                        showOtpSection = true;
                      });
                    }

                    if (state is GetOtpErrorState) {
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
                      child: showOtpSection
                          ? OtpSection(
                              phone: phoneController.text,
                              onChangePhone: _onChangePhone,
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

  // 📲 Get OTP
  void getOtp() {
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

  void _onChangePhone() {
    setState(() {
      showOtpSection = false;
      phoneController.clear();
    });
  }
}
