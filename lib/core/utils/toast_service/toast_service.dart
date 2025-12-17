part of 'index.dart';

class ToastService {
  static void showSuccess(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isDark ? Colors.white : Colors.black87,
      textColor: isDark ? Colors.black : Colors.white,
      fontSize: 12.0,
    );
  }

  static void showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 12.0,
    );
  }

  // 3. Info (Neutral Grey)
  static void showInfo(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[700],
      textColor: Colors.white,
      fontSize: 12.0,
    );
  }
}
