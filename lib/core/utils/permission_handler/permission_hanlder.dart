part of 'index.dart';

class PermissionService {
  static Future<bool> requestLocationPermissions() async {
    // Foreground permission
    PermissionStatus whenInUse = await Permission.locationWhenInUse.status;

    if (!whenInUse.isGranted) {
      whenInUse = await Permission.locationWhenInUse.request();
      if (!whenInUse.isGranted) return false;
    }

    // Background permission (important for SOS)
    PermissionStatus always = await Permission.locationAlways.status;
    if (!always.isGranted) {
      always = await Permission.locationAlways.request();
    }

    return whenInUse.isGranted;
  }
}

Future<bool> showEnableGpsDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Enable Location'),
          content: const Text(
            'Location services are required to continue. Please turn on GPS.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: AppFontStyles.bodySmallBold(context),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Enable',
                style: AppFontStyles.bodySmallBold(context),
              ),
            ),
          ],
        ),
      ) ??
      false;
}

class LocationService {
  static Future<Position> getCurrentLocation(BuildContext context) async {
    // 1️⃣ Check permissions
    final hasPermission = await PermissionService.requestLocationPermissions();

    if (!hasPermission) {
      throw Exception('Location permission denied');
    }

    // 2️⃣ Check GPS
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      final shouldOpenSettings = await showEnableGpsDialog(context);

      if (!shouldOpenSettings) {
        throw Exception('GPS not enabled by user');
      }

      // Open system settings
      await Geolocator.openLocationSettings();

      // Wait & retry
      await Future.delayed(const Duration(seconds: 3));
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception('GPS still disabled');
      }
    }

    // 3️⃣ Get location
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
