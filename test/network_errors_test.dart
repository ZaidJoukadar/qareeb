import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/core/network/network_errors.dart';

void main() {
  group('isNetworkError', () {
    test('returns true for SocketException', () {
      expect(isNetworkError(const SocketException('no network')), isTrue);
    });

    test('returns true for Dio connection errors', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionError,
      );

      expect(isNetworkError(error), isTrue);
    });

    test('returns true for Dio timeouts', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.receiveTimeout,
      );

      expect(isNetworkError(error), isTrue);
    });

    test('returns false for bad HTTP responses', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 500,
        ),
      );

      expect(isNetworkError(error), isFalse);
    });

    test('returns false for format errors', () {
      expect(isNetworkError(const FormatException('bad json')), isFalse);
    });
  });
}
