class ApiException implements Exception {
  final int    statusCode;
  final String errorCode;
  final String message;

  const ApiException({
    required this.statusCode,
    required this.errorCode,
    required this.message,
  });

  factory ApiException.fromJson(int statusCode, Map<String, dynamic> json) {
    return ApiException(
      statusCode: statusCode,
      errorCode:  json['errorCode'] as String? ?? 'UNKNOWN',
      message:    json['message']   as String? ?? 'An unexpected error occurred.',
    );
  }

  @override
  String toString() => 'ApiException($statusCode, $errorCode): $message';
}
