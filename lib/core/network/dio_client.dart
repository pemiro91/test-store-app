import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      validateStatus: (status) {
        return status != null && status > 0;
      },
      responseType: ResponseType.json,
    ),
  );

  DioClient() {
    dio.interceptors.addAll([_loggingInterceptor()]);
  }

  Interceptor _loggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint('➡️ REQUEST[${options.method}] => PATH: ${options.uri}');
        debugPrint('Headers: ${options.headers}');
        if (options.data != null) debugPrint('Data: ${options.data}');
        if (options.queryParameters.isNotEmpty) {
          debugPrint('Query: ${options.queryParameters}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint(
          '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.uri}',
        );
        debugPrint('Response: ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        debugPrint(
          '⛔ ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.uri}',
        );
        debugPrint('Message: ${error.message}');
        if (error.response != null) {
          debugPrint('Error Response: ${error.response?.data}');
        }
        return handler.next(error);
      },
    );
  }
}
