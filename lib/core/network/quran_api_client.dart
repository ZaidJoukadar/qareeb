import 'package:dio/dio.dart';
import 'package:qareeb/core/config/environment.dart';

Dio createQuranApiClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.current.quranApiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 120),
      headers: {
        'Accept': 'application/json',
        'Accept-Encoding': 'gzip',
      },
    ),
  );
  return dio;
}
