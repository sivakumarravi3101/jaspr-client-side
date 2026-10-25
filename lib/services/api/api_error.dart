import 'api_error_code.dart';

class ApiError implements Exception {
  const ApiError({
    required this.code,
    required this.responseMessage,
    this.responseCode,
  });

  final ApiErrorCode code;
  final int? responseCode;
  final String responseMessage;

  @override
  String toString() => responseMessage;
}
