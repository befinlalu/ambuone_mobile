part of 'index.dart';

class LockSosService {
  static const MethodChannel _channel = MethodChannel('lock_sos');

  static Future<void> startSos() async {
    final notificationStatus = await Permission.notification.request();
    if (!notificationStatus.isGranted) return;
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

  static Future<bool> isAccessibilityEnabled() async {
    try {
      return await _channel.invokeMethod('isAccessibilityServiceEnabled');
    } catch (e) {
      return false;
    }
  }

  static Future<void> openAccessibilitySettings() async {
    try {
      await _channel.invokeMethod('openAccessibilitySettings');
    } catch (e) {
      debugPrint("Error opening settings: $e");
    }
  }

  static Future<void> pinWidget() async {
    try {
      await _channel.invokeMethod('pinSosWidget');
    } catch (e) {
      debugPrint("Failed to pin widget: $e");
    }
  }

  static Future<void> requestBatteryOptimizationExemption() async {
    try {
      await _channel.invokeMethod('requestBatteryOptimization');
    } catch (e) {
      debugPrint("Error requesting battery optimization: $e");
    }
  }
}
