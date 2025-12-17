part of 'index.dart';

Color primaryColor = const Color(0xFF1A9CDC);
Color backgroundColor1 = const Color(0xFF1E1E1E);
Color backgroundColor2 = const Color(0xFF353542);
Color textColor1 = const Color(0xffFFFFFF);
Color textColor2 = const Color(0xffA3A1A1);
Color redColor = const Color(0xffD12727);
Color orangeColor = const Color(0xffFFA699);
Color greenColor = const Color(0xff307351);
Color backgroundLight2 = const Color(0xFFCAEBF7);
Color backgroundLight1 = const Color(0xFFFCFEFF);

class AppColors {
  static const Color primaryColor = Color(0xFF22AADE);
  static const Color backgroundColor1 = Color(0xFF1E1E1E);
  static const Color backgroundColor2 = Color(0xFF353542);
  static const Color textColor1 = Color(0xFFFFFFFF);
  static const Color textColor2 = Color(0xFFA3A1A1);
  static const Color textColor3 = Color.fromARGB(255, 118, 117, 117);
  static const Color redColor = Color(0xFFB10F2E);
  static const Color orangeColor = Color(0xFFFFA699);
  static const Color greenColor = Color(0xFF307351);
  static const Color barrierColor = Color.fromRGBO(0, 0, 0, 0.4);
  static const Color barrierColor2 = Color.fromRGBO(216, 216, 216, 0.4);
}

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  textTheme: Typography.blackCupertino,
  scaffoldBackgroundColor: backgroundLight1,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: backgroundLight1,
    secondary: backgroundLight2,
    tertiary: primaryColor,
    onSecondary: backgroundColor2,
    onPrimary: backgroundColor1,
  ),
);
