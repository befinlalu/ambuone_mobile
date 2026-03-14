part of 'index.dart';

// class AutoStartHelper {
//   static Future<void> checkAndOpenAutoStart(BuildContext context) async {
//     if (!Platform.isAndroid) return;

//     final androidInfo = await DeviceInfoPlugin().androidInfo;
//     final manufacturer = androidInfo.manufacturer.toLowerCase();

//     // Check if it's a brand that kills apps
//     if (manufacturer.contains('xiaomi') ||
//         manufacturer.contains('redmi') ||
//         manufacturer.contains('oppo') ||
//         manufacturer.contains('vivo') ||
//         manufacturer.contains('huawei')) {
//       _showExplanationDialog(context, manufacturer);
//     }
//   }

//   static void _showExplanationDialog(BuildContext context, String brand) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Enable Auto-Start'),
//         content: Text(
//           'On $brand devices, you must manually allow "AmbuOne" to Auto-Start, or the SOS button will disappear.\n\n'
//           '1. We will open Settings.\n'
//           '2. Find "Auto Start" or "Background Power".\n'
//           '3. Turn it ON for AmbuOne.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           FilledButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _openAutoStartSettings(brand);
//             },
//             child: const Text('Go to Settings'),
//           ),
//         ],
//       ),
//     );
//   }

//   static Future<void> _openAutoStartSettings(String manufacturer) async {
//     String? componentName;

//     // Try the specific "Hidden" menus first
//     if (manufacturer.contains('xiaomi') || manufacturer.contains('redmi')) {
//       // MIUI 10-12
//       componentName =
//           'com.miui.securitycenter/com.miui.permcenter.autostart.AutoStartManagementActivity';
//     } else if (manufacturer.contains('oppo')) {
//       componentName =
//           'com.coloros.safecenter/com.coloros.safecenter.permission.startup.StartupAppListActivity';
//     } else if (manufacturer.contains('vivo')) {
//       componentName =
//           'com.vivo.permissionmanager/com.vivo.permissionmanager.activity.BgStartUpManagerActivity';
//     }

//     if (componentName != null) {
//       try {
//         final intent = AndroidIntent(
//           action: 'android.intent.action.MAIN',
//           componentName: componentName,
//           flags: <int>[268435456], // FLAG_ACTIVITY_NEW_TASK
//         );
//         await intent.launch();
//         return; // Success!
//       } catch (e) {
//         print("Specific Auto-Start intent failed: $e");
//         // Fallthrough to the generic method below
//       }
//     }

//     // FALLBACK: If the specific menu fails (HyperOS, new MIUI), open the App Details page.
//     // The user can find "Permissions" -> "AutoStart" there.
//     await openAppSettings();
//   }
// }
