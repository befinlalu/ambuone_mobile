part of 'index.dart';

abstract class BaseRepository {
  Future<ApiResponse<T>> apiCall<T>(Future<T?> Function() apiCall) async {
    try {
      final result = await apiCall();

      return ApiResponse.fromJson(json: result, success: true, data: result);
    } on ApiException catch (e) {
      return ApiResponse.fromJson(json: e.error, success: false);
    } catch (e) {
      return ApiResponse.fromJson(json: e.toString(), success: false);
    }
  }
}
