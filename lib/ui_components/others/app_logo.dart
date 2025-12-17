part of 'index.dart';

class AppLogo extends StatelessWidget {
  final double height;
  const AppLogo({super.key, this.height = 150});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.asset(AppImages.appLogo),
        ),
      ),
    );
  }
}
