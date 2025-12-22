part of 'index.dart';

class LockSosService {
  static const MethodChannel _channel = MethodChannel('lock_sos');

  static Future<void> startSos() async {
    await Permission.notification.request();
    await _channel.invokeMethod('startSosService');
  }

  static Future<void> stopSos() async {
    await _channel.invokeMethod('stopSosService');
  }
}
