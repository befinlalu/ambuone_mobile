part of 'index.dart';

abstract class BaseRepository {
  Future<ApiResponse<T>> apiCall<T>(Future<T?> Function() apiCall) async {
    try {
      final result = await apiCall();

      return ApiResponse.fromJson(json: result, success: true);
    } on RepositoryException catch (e) {
      return ApiResponse.fromJson(json: e.message, success: false);
    } on UnAuthenticateException catch (e) {
      return ApiResponse.fromJson(json: e.message, success: false);
    } catch (_) {
      return ApiResponse.fromJson(json: null, success: false);
    }
  }
}
