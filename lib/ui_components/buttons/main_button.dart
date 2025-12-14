part of 'index.dart';

class MainButton extends StatelessWidget {
  final Color buttonColor;
  final String buttonTitle;
  final TextStyle? textStyle;
  final Function()? onPressed;
  final double width;
  final double height;
  final IconData? icon;
  const MainButton({
    super.key,
    required this.buttonColor,
    required this.buttonTitle,
    this.textStyle,
    this.onPressed,
    this.width = double.infinity,
    this.height = 50,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Styling for the container
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: buttonColor, width: 1),
      ),
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor, // Button background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32), // Button shape
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            color: Colors.transparent,
            child: icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        buttonTitle,
                        style:
                            textStyle ??
                            AppFontStyles.smallButtonTextStyle(context),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        icon,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 20,
                      ),
                    ],
                  )
                : Text(
                    buttonTitle,
                    style:
                        textStyle ??
                        AppFontStyles.smallButtonTextStyle(context),
                  ),
          ),
        ),
      ),
    );
  }
}
