import 'package:dio/dio.dart';

Dio createPollinationsApiClient() {
  return Dio(
    BaseOptions(
      baseUrl: 'https://text.pollinations.ai',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 120),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
}
