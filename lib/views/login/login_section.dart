part of 'index.dart';

class LoginSection extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onPressed;

  const LoginSection({super.key, this.controller, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("LOGIN", style: AppFontStyles.h6(context)),
        const SizedBox(height: 12),

        PrimaryTextFormField(
          label: 'Phone Number',
          maxLenth: 10,
          controller: controller,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 32),
        MainButton(
          buttonColor: AppColors.redColor,
          buttonTitle: 'Login',
          textStyle: TextStyle(color: Colors.white),
          onPressed: onPressed,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("or", style: AppFontStyles.h6Hint(context))],
        ),
        SizedBox(height: 20),
        MainButton(
          buttonColor: Theme.of(context).colorScheme.tertiary,
          buttonTitle: 'Subscribe now',
          textStyle: TextStyle(color: Colors.white),
          onPressed: () {
            context.push(PageRoutes.register);
          },
        ),
      ],
    );
  }
}
