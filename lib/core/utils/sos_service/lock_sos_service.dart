part of 'index.dart';

class LockSosService {
  static const MethodChannel _channel = MethodChannel('lock_sos');

  /// Start SOS + ask for battery optimization exemption (Android only)
  static Future<void> startSos() async {
    // 1️⃣ Notification permission (Android 13+)
    final notificationStatus = await Permission.notification.request();
    if (!notificationStatus.isGranted) {
      return;
    }

    // 2️⃣ Start foreground service
    await _channel.invokeMethod('startSosService');

    // 3️⃣ Ask battery optimization exemption (ONLY ONCE)
    if (Platform.isAndroid) {
      final enabled = SharedStorages().getSosStatus();

      if (!enabled) {
        await _requestIgnoreBatteryOptimizations();
      }
    }
  }

  /// Stop SOS foreground service
  static Future<void> stopSos() async {
    await _channel.invokeMethod('stopSosService');
  }

  /// Internal: open system dialog to ignore battery optimizations
  static Future<void> _requestIgnoreBatteryOptimizations() async {
    const intent = AndroidIntent(
      action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
      data: 'package:com.ambuone.prod',
    );
    await intent.launch();
  }
}
