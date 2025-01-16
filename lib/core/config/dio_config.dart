// File: lib/core/network/dio_config.dart
import 'package:attendance_ktp/core/config/config_resources.dart';
import 'package:dio/dio.dart';

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: StringResources.baseUrl, // Ganti dengan URL yang sesuai
      connectTimeout: const Duration(seconds: StringResources.timeOutServer),
      receiveTimeout: const Duration(seconds: StringResources.timeOutServer),
      headers: StringResources.headers,
    ),
  );
  return dio;
}
