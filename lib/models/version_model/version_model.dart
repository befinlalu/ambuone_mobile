part of 'index.dart';

class VersionModel {
  final bool appMaintenance;
  final String currentVersion;
  final String minVersion;

  const VersionModel({
    required this.appMaintenance,
    required this.currentVersion,
    required this.minVersion,
  });

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    return VersionModel(
      appMaintenance: json['appMaintenance'] as bool? ?? false,
      currentVersion: json['currentVersion'] as String? ?? '0.0.0',
      minVersion: json['minVersion'] as String? ?? '0.0.0',
    );
  }

  /// True if installedVersion is below minVersion
  bool requiresUpdate(String installedVersion) {
    return _compare(installedVersion, minVersion) < 0;
  }

  int _compare(String a, String b) {
    final ap = a.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final bp = b.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final len = ap.length > bp.length ? ap.length : bp.length;
    for (int i = 0; i < len; i++) {
      final av = i < ap.length ? ap[i] : 0;
      final bv = i < bp.length ? bp[i] : 0;
      if (av < bv) return -1;
      if (av > bv) return 1;
    }
    return 0;
  }
}
