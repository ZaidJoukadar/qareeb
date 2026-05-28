import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

/// Whether [error] is likely caused by connectivity, DNS, or timeouts.
bool isNetworkError(Object error) {
  if (error is SocketException || error is HandshakeException) {
    return true;
  }
  if (error is TimeoutException) {
    return true;
  }
  if (error is DioException) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => true,
      _ => false,
    };
  }
  return false;
}
