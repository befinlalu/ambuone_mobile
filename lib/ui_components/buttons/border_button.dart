part of 'index.dart';

class BorderButton extends StatelessWidget {
  final Color buttonColor;
  final String buttonTitle;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final double width;
  final double height;

  const BorderButton({
    super.key,
    required this.buttonColor,
    required this.buttonTitle,
    this.textStyle,
    this.onPressed,
    this.width = double.infinity,
    this.height = 35,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: buttonColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Text(
          buttonTitle,
          style: textStyle ?? AppFontStyles.bodySmallBold(context),
        ),
      ),
    );
  }
}
