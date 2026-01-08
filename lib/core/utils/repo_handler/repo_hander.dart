part of 'index.dart';

class RepositoryHandler {
  Future<T?> handlePostRequest<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await HttpServices().post(endpoint, body: body);
    return fromJson(response);
  }

  Future<List<T>> handlePostListRequest<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await HttpServices().post(endpoint, body: body);
    return (response as List)
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<T?> handleGetRequest<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await HttpServices().get(endpoint);
    final json = fromJson(response);
    return json;
  }

  Future<T?> handlePatchRequest<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await HttpServices().patch(endpoint, body: body);
    return fromJson(response);
  }

  Future<T?> handlePutRequest<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await HttpServices().put(endpoint, body: body);
    return fromJson(response);
  }

  Future<List<T>> handlePutListRequest<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await HttpServices().put(endpoint, body: body);

    return (response as List)
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<T?> handleDeleteRequest<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await HttpServices().delete(endpoint);
    return fromJson(response);
  }

  Future<T?> handleDeleteRequestWithBody<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await HttpServices().delete(endpoint, body: body);
    return fromJson(response);
  }
  // ---------------- MULTIPART SUPPORT ----------------

  Future<T?> handleMultipartPostRequest<T>({
    required String endpoint,
    required Map<String, String> fields,
    Map<String, File>? files,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await HttpServices().postMultipart(
      endpoint,
      fields: fields,
      files: files,
    );

    // In case API returns null (204 etc.)
    if (response == null) return null;

    return fromJson(response as Map<String, dynamic>);
  }

  Future<T?> handleMultipartPatchRequest<T>({
    required String endpoint,
    required Map<String, String> fields,
    Map<String, File>? files,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await HttpServices().patchMultipart(
      endpoint,
      fields: fields,
      files: files,
    );

    // In case API returns null (204 etc.)
    if (response == null) return null;

    return fromJson(response as Map<String, dynamic>);
  }

  Future<List<T>> handleMultipartPostListRequest<T>({
    required String endpoint,
    required Map<String, String> fields,
    Map<String, File>? files,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await HttpServices().postMultipart(
      endpoint,
      fields: fields,
      files: files,
    );

    return (response as List)
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
