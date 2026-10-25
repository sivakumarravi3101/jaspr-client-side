import 'package:dio/dio.dart';

import 'api_error.dart';
import 'api_error_code.dart';

class ApiClient {
  ApiClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://exportstatistics-web-api.onrender.com/api/market-insight/',
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 30),
              sendTimeout: const Duration(seconds: 20),
              headers: const {'Accept': 'application/json'},
            ),
          );

  final Dio _dio;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final data = await _request(path, queryParameters: queryParameters);
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);

    throw const ApiError(
      code: ApiErrorCode.invalidResponse,
      responseMessage: 'The server returned an unexpected response format.',
    );
  }

  Future<List<dynamic>> getList(String path) async {
    final data = await _request(path);
    if (data is List) return data;

    throw const ApiError(
      code: ApiErrorCode.invalidResponse,
      responseMessage: 'The server returned an unexpected list response format.',
    );
  }

  Future<Object?> _request(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<Object?>(
        path,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  ApiError _mapDioError(DioException error) {
    final responseCode = error.response?.statusCode;
    final responseBody = error.response?.data;
    final responseMessage = switch (responseBody) {
      Map body when body['message'] is String => body['message'] as String,
      Map body when body['title'] is String => body['title'] as String,
      _ => error.message,
    };

    return ApiError(
      code: switch (error.type) {
        DioExceptionType.connectionTimeout => ApiErrorCode.connectionTimeout,
        DioExceptionType.sendTimeout => ApiErrorCode.sendTimeout,
        DioExceptionType.receiveTimeout => ApiErrorCode.receiveTimeout,
        DioExceptionType.badResponse => ApiErrorCode.badResponse,
        DioExceptionType.cancel => ApiErrorCode.cancelled,
        DioExceptionType.connectionError => ApiErrorCode.connection,
        _ => ApiErrorCode.unknown,
      },
      responseCode: responseCode,
      responseMessage:
          responseMessage?.toString() ??
          (responseCode == null
              ? 'Unable to connect to the trade data service.'
              : 'The trade data service returned HTTP $responseCode.'),
    );
  }
}
