part of 'index.dart';

class AppFontStyles {
  static TextStyle h1(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 36),
    fontWeight: FontWeight.bold,
  );
  static TextStyle h2(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 30),
    fontWeight: FontWeight.bold,
  );
  static TextStyle h3(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 25),
    fontWeight: FontWeight.bold,
  );
  static TextStyle h4(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 21),
    fontWeight: FontWeight.bold,
  );
  static TextStyle h5(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 17),
    fontWeight: FontWeight.bold,
  );
  static TextStyle h6(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 14),
    fontWeight: FontWeight.bold,
  );
  static TextStyle h6Itallic(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 14),
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
  );
  static TextStyle h6Hint(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onSecondary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 14),
    fontWeight: FontWeight.w500,
  );
  static TextStyle h6Error(BuildContext context) => TextStyle(
    color: AppColors.redColor,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 14),
    fontWeight: FontWeight.w500,
  );

  static TextStyle bodySmall(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 12),
    fontWeight: FontWeight.normal,
  );

  static TextStyle bodySmallBold(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 12),
    fontWeight: FontWeight.bold,
  );
  static TextStyle bodySmallHint(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onSecondary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 12),
    fontWeight: FontWeight.normal,
  );
  static TextStyle bodySmallError(BuildContext context) => TextStyle(
    color: AppColors.redColor,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 12),
    fontWeight: FontWeight.normal,
  );

  static TextStyle headingStyleX(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 20),
    fontWeight: FontWeight.w600,
  );

  static TextStyle headingStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 16),
    fontWeight: FontWeight.w600,
  );
  static TextStyle bodyStyleMain(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 14),
    fontWeight: FontWeight.w400,
  );
  static TextStyle bodyStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onSecondary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 14),
    fontWeight: FontWeight.w400,
  );

  static TextStyle subTitleStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 14),
    fontWeight: FontWeight.w400,
  );

  static TextStyle smallButtonTextStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 14),
    fontWeight: FontWeight.w600,
  );

  static TextStyle smallSocialButtonTextStyle(BuildContext context) =>
      TextStyle(
        color: AppColors.backgroundColor1,
        fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 14),
        fontWeight: FontWeight.w600,
      );

  static TextStyle xsmallButtonTextStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 12),
    fontWeight: FontWeight.w600,
  );

  static TextStyle smallTextStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onSecondary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 12),
    fontWeight: FontWeight.normal,
  );
  static TextStyle errorTextStyle(BuildContext context) => TextStyle(
    color: AppColors.redColor,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 12),
    fontWeight: FontWeight.w500,
  );
  static TextStyle xSmallTextStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onSecondary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 10),
    fontWeight: FontWeight.w400,
  );
  static TextStyle xSmallTextStyleMain(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 10),
    fontWeight: FontWeight.w400,
  );

  static TextStyle transcationStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 16),
    fontWeight: FontWeight.w600,
  );
  static TextStyle transcationStyleGreen(BuildContext context) => TextStyle(
    color: AppColors.greenColor,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 16),
    fontWeight: FontWeight.w600,
  );
  static TextStyle transcationStyleRed(BuildContext context) => TextStyle(
    color: AppColors.redColor,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 16),
    fontWeight: FontWeight.w600,
  );
  static TextStyle transcationStyleDeleted(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onSecondary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 18),
    fontWeight: FontWeight.w600,
  );
  static TextStyle transactionStyleX(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 20),
    fontWeight: FontWeight.w600,
  );
  static TextStyle transactionStyleGrey(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onSecondary,
    fontSize: ResponsiveSizeUtil.getResponsiveFontSize(context, 20),
    fontWeight: FontWeight.w600,
  );
}

class ResponsiveSizeUtil {
  static const double _designWidth = 414.0;

  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textScaler = MediaQuery.textScalerOf(context);

    final scaleFactor = min(screenWidth / _designWidth, 1.0);

    final scaledSize = baseSize * scaleFactor;

    return textScaler.scale(scaledSize).clamp(baseSize * 0.85, baseSize * 1.2);
  }
}
