part of 'index.dart';

class LockSosService {
  static const MethodChannel _channel = MethodChannel('lock_sos');

  static Future<void> startSos() async {
    final notificationStatus = await Permission.notification.request();
    if (!notificationStatus.isGranted) {
      return;
    }
    try {
      await _channel.invokeMethod('startSosService');
    } catch (e) {
      debugPrint("Error starting SOS service: $e");
    }
  }

  static Future<void> stopSos() async {
    try {
      await _channel.invokeMethod('stopSosService');
    } catch (e) {
      debugPrint("Error stopping SOS service: $e");
    }
  }
}
