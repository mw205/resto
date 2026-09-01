import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('➡️ [DIO REQ] ${options.method} => ${options.uri}');
      if (options.data != null) {
        debugPrint('Payload: ${options.data}');
      }
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('✅ [DIO RESP] ${response.statusCode} <= ${response.requestOptions.uri}');
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('❌ [DIO ERR] ${err.response?.statusCode} <= ${err.requestOptions.uri} | ${err.message}');
    }
    return handler.next(err);
  }
}
