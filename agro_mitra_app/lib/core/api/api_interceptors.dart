import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

class ApiInterceptors extends Interceptor {
  final Logger _logger = Logger();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    }

    if (kDebugMode) {
      _logger.d('REQUEST[${options.method}] => PATH: ${options.path}');
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.d('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      _logger.e('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    }

    if (err.response?.statusCode == 401) {
      try {
        await Supabase.instance.client.auth.refreshSession();
        final options = err.requestOptions;
        final response = await Dio().fetch(options);
        return handler.resolve(response);
      } catch (e) {
        await Supabase.instance.client.auth.signOut();
      }
    }
    return super.onError(err, handler);
  }
}
