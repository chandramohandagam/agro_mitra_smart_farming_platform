import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() => "ApiException: $message (Status: $statusCode)";
}

class NetworkException extends ApiException {
  NetworkException({required super.message, super.statusCode});
}

class AuthException extends ApiException {
  AuthException({required super.message, super.statusCode});
}

class ValidationException extends ApiException {
  ValidationException({required super.message, super.statusCode, super.data});
}
