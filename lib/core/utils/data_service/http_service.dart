part of 'index.dart';

class HttpServices {
  String cookie = '';
  final accessToken = SharedStorages().getAccessToken();

  Map<String, String> get _defaultHeaders {
    final headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (accessToken != null && accessToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    return headers;
  }

  final baseUrl = ServiceConstants.urls.prodApi;

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse(baseUrl + endpoint);
    try {
      debugPrint('url $url');
      final response = await http
          .get(url, headers: {..._defaultHeaders, ...?headers})
          .timeout(const Duration(seconds: 30));
      debugPrint('response ${response.body}');
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No Internet connection');
    } on TimeoutException {
      throw TimeoutException('Request timeout');
    }
  }

  Future<dynamic> location(String endpoint) async {
    final url = Uri.parse(endpoint);
    try {
      debugPrint('url $url');
      final response = await http.get(url).timeout(const Duration(seconds: 30));
      debugPrint('response ${response.body}');
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No Internet connection');
    } on TimeoutException {
      throw TimeoutException('Request timeout');
    }
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final url = Uri.parse(baseUrl + endpoint);
    debugPrint('url $url');
    debugPrint(jsonEncode(body));
    try {
      final response = await http
          .post(
            url,
            headers: headers ?? _defaultHeaders,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 60));
      debugPrint('Response: ${response.body}');
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No Internet connection');
    } on TimeoutException {
      throw TimeoutException('Request timeout');
    }
  }

  Future<dynamic> patch(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final url = Uri.parse(baseUrl + endpoint);
    debugPrint('url $url');
    debugPrint(jsonEncode(body));
    try {
      final response = await http
          .patch(
            url,
            headers: headers ?? _defaultHeaders,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No Internet connection');
    } on TimeoutException {
      throw TimeoutException('Request timeout');
    }
  }

  Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final url = Uri.parse(baseUrl + endpoint);
    debugPrint('url $url');
    debugPrint(jsonEncode(body));
    try {
      final response = await http
          .put(url, headers: headers ?? _defaultHeaders, body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No Internet connection');
    } on TimeoutException {
      throw TimeoutException('Request timeout');
    }
  }

  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final url = Uri.parse(baseUrl + endpoint);
    debugPrint('url $url');
    if (body != null) {
      debugPrint(jsonEncode(body));
    }

    try {
      final request = http.Request('DELETE', url);

      request.headers.addAll(headers ?? _defaultHeaders);
      if (body != null) {
        request.body = jsonEncode(body);
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 10),
      );

      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No Internet connection');
    } on TimeoutException {
      throw TimeoutException('Request timeout');
    }
  }

  Future<dynamic> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    Map<String, File>? files, // key = field name
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(baseUrl + endpoint);
    debugPrint('url $url');

    try {
      final request = http.MultipartRequest('POST', url);

      // Headers (DO NOT set Content-Type manually)
      request.headers.addAll(
        {..._defaultHeaders, ...?headers}..remove('Content-Type'),
      );

      // Add fields
      request.fields.addAll(fields);

      // Add files
      if (files != null) {
        for (final entry in files.entries) {
          final file = entry.value;
          final fieldName = entry.key;

          request.files.add(
            await http.MultipartFile.fromPath(fieldName, file.path),
          );
        }
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );

      final response = await http.Response.fromStream(streamedResponse);
      debugPrint('Response: ${response.body}');

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No Internet connection');
    } on TimeoutException {
      throw TimeoutException('Request timeout');
    }
  }

  dynamic _handleResponse(http.Response response) {
    debugPrint('Status code : ${response.statusCode}');

    dynamic decodedBody;
    if (response.bodyBytes.isNotEmpty) {
      try {
        decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
      } catch (_) {
        decodedBody = response.body;
      }
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return decodedBody;

      case 204:
        return null;

      case 401:
        throw UnAuthenticateException(
          decodedBody ?? 'Unauthorized',
          response.statusCode,
        );

      case 403:
        throw UnAuthenticateException(decodedBody, response.statusCode);

      case 400:
      case 404:
      case 405:
      case 422:
      case 429:
        throw CustomException(decodedBody, response.statusCode);

      case 500:
      case 502:
      case 503:
      default:
        throw CustomException(
          decodedBody ?? 'Server error',
          response.statusCode,
        );
    }
  }
}
