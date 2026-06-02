import 'package:dio/dio.dart';

Dio createQuranComApiClient() {
  return Dio(
    BaseOptions(
      baseUrl: 'https://api.quran.com/api/v4',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Accept': 'application/json',
        'Accept-Encoding': 'gzip',
      },
    ),
  );
}
