import 'package:dio/dio.dart';
import '../config/env_config.dart';
import 'api_interceptors.dart';
import 'api_exceptions.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.backendUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        validateStatus: (status) => status! < 500,
      ),
    );
    _dio.interceptors.add(ApiInterceptors());
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Response _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      throw ValidationException(
        message: response.data['message'] ?? 'Validation Error',
        statusCode: response.statusCode,
        data: response.data,
      );
    } else if (response.statusCode == 401) {
      throw AuthException(message: 'Unauthorized', statusCode: 401);
    } else if (response.statusCode == 403) {
      throw ApiException(message: 'Forbidden', statusCode: 403);
    } else if (response.statusCode == 404) {
      throw ApiException(message: 'Not Found', statusCode: 404);
    } else if (response.statusCode == 409) {
      throw ApiException(message: 'Conflict', statusCode: 409);
    } else {
      throw ApiException(message: 'Server Error', statusCode: response.statusCode);
    }
  }

  ApiException _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkException(message: 'Connection Timeout');
    } else if (e.type == DioExceptionType.connectionError) {
      return NetworkException(message: 'No Internet Connection');
    }
    return ApiException(message: e.message ?? 'Unknown Error');
  }
}
