part of 'index.dart';

abstract class VersionRepo {
  Future<ApiResponse<VersionModel>> getVersion();
}
