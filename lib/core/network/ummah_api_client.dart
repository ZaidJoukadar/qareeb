import 'package:dio/dio.dart';
import 'package:qareeb/core/config/environment.dart';

Dio createUmmahApiClient() {
  return Dio(
    BaseOptions(
      baseUrl: Environment.current.ummahApiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 120),
      headers: {
        'Accept': 'application/json',
        'Accept-Encoding': 'gzip',
      },
    ),
  );
}
