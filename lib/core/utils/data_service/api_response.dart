part of 'index.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? raw;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.raw,
  });

  /// Factory constructor to parse ANY backend response
  factory ApiResponse.fromJson({
    required dynamic json,
    bool success = true,
    T? data,
  }) {
    return ApiResponse(
      success: success,
      message: _extractMessage(json),
      data: data,
      raw: json is Map<String, dynamic> ? json : null,
    );
  }

  /// Handles all known + unknown message formats
  static String _extractMessage(dynamic json) {
    if (json == null) {
      return 'Something went wrong. Please try again.';
    }

    if (json is String) {
      return json;
    }

    if (json is Map<String, dynamic>) {
      // ✅ ADD THIS (for 429, 400, etc.)
      if (json.containsKey('error')) {
        return json['error'].toString();
      }

      // Existing logic
      if (json.containsKey('message')) {
        return json['message'].toString();
      }

      if (json.containsKey('non_field_errors')) {
        final errors = json['non_field_errors'];
        if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        }
      }

      for (final value in json.values) {
        if (value is List && value.isNotEmpty) {
          return value.first.toString();
        }
      }
    }

    return 'Unexpected error occurred.';
  }
}
