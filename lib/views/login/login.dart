part of 'index.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
                  Image.asset(
                    AppImages.authLogo, // your image
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.15),
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("LOGIN", style: AppFontStyles.h6(context)),
                        const SizedBox(height: 12),

                        PrimaryTextFormField(label: 'Phone Number'),
                        const SizedBox(height: 32),
                        MainButton(
                          buttonColor: AppColors.redColor,
                          buttonTitle: 'Login',
                          textStyle: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("or", style: AppFontStyles.h6Hint(context)),
                          ],
                        ),
                        SizedBox(height: 20),
                        MainButton(
                          buttonColor: Theme.of(context).colorScheme.tertiary,
                          buttonTitle: 'Subscribe now',
                          textStyle: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
