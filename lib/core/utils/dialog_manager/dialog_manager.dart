part of 'index.dart';

class DialogManager {
  DialogManager._privateConstructor();

  static final DialogManager instance = DialogManager._privateConstructor();

  /// Show a loading dialog
  void showLoadingDialog(BuildContext context, {String? message}) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: isDarkMode
          ? AppColors.barrierColor
          : AppColors.barrierColor2,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    message ?? 'Loading...',
                    style: AppFontStyles.h6(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Auth loading dialog

  void showDialogSuccess(BuildContext context, {String? message}) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: isDarkMode
          ? AppColors.barrierColor
          : AppColors.barrierColor2,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 40, color: greenColor),
                  const SizedBox(height: 16.0),
                  Text(
                    message ?? 'Loading...',
                    style: AppFontStyles.h6(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Hide the loading dialog
  void hideLoadingDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Widget showLoading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }

  showAppDialog(
    BuildContext context, {
    required String title,
    String? subTitle,
    String? buttonText,
  }) async {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: isDarkMode
          ? AppColors.barrierColor
          : AppColors.barrierColor2,
      builder: (BuildContext context) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(
                  title,
                  style: AppFontStyles.h6(context),
                  textAlign: TextAlign.left,
                ),
                content: Text(
                  subTitle ?? '',
                  style: AppFontStyles.bodySmall(context),
                  textAlign: TextAlign.left,
                ),
                actions: <CupertinoDialogAction>[
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      'Cancel',
                      style: AppFontStyles.bodySmallHint(context),
                    ),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: false,
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      buttonText ?? 'Confirm',
                      style: AppFontStyles.bodySmall(context),
                    ),
                  ),
                ],
              )
            : AlertDialog(
                contentPadding: const EdgeInsets.all(12),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: AppFontStyles.h6(context),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Text(
                          subTitle ?? '',
                          style: AppFontStyles.bodySmall(context),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'Cancel',
                      style: AppFontStyles.bodySmallHint(context),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  TextButton(
                    child: Text(
                      buttonText ?? 'Confirm',
                      style: AppFontStyles.bodySmall(context),
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ],
              );
      },
    );
  }

  showAppWarningDialog(
    BuildContext context, {
    required String title,
    String? subTitle,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(
                  title,
                  style: AppFontStyles.h6(context),
                  textAlign: TextAlign.center,
                ),
                content: Text(subTitle ?? '', textAlign: TextAlign.center),
                actions: <CupertinoDialogAction>[
                  CupertinoDialogAction(
                    isDestructiveAction: false,
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Ok'),
                  ),
                ],
              )
            : AlertDialog(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Text(
                  title,
                  style: AppFontStyles.h6(context),
                  textAlign: TextAlign.center,
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(subTitle ?? '', textAlign: TextAlign.left),
                    ],
                  ),
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'Ok',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ],
              );
      },
    );
  }
}
