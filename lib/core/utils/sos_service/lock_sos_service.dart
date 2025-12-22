part of 'index.dart';

class LockSosService {
  static const MethodChannel _channel = MethodChannel('lock_sos');

  /// Call Android to request pinned shortcut
  static Future<void> enableLockSos(BuildContext context) async {
    try {
      // await _channel.invokeMethod('enableLockSos');
      await _channel.invokeMethod('showSosNotification');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tap "Add" to place SOS shortcut on home screen'),
        ),
      );
    } catch (e) {
      debugPrint('Lock SOS error: $e');
    }
  }
}
