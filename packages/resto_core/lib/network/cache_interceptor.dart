import 'package:dio/dio.dart';

class CacheInterceptor extends Interceptor {
  final Map<String, _CachedItem> _cache = {};
  final Duration defaultMaxAge;

  CacheInterceptor({this.defaultMaxAge = const Duration(minutes: 5)});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method.toUpperCase() != 'GET') {
      return handler.next(options);
    }

    final key = options.uri.toString();
    final cachedItem = _cache[key];

    if (cachedItem != null && !cachedItem.isExpired) {
      return handler.resolve(
        Response(
          requestOptions: options,
          data: cachedItem.response.data,
          statusCode: cachedItem.response.statusCode,
          headers: cachedItem.response.headers,
        ),
      );
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.method.toUpperCase() == 'GET' && response.statusCode == 200) {
      final key = response.requestOptions.uri.toString();
      _cache[key] = _CachedItem(response, DateTime.now().add(defaultMaxAge));
    }
    return handler.next(response);
  }

  void clearCache() {
    _cache.clear();
  }
}

class _CachedItem {
  final Response response;
  final DateTime expiry;

  _CachedItem(this.response, this.expiry);

  bool get isExpired => DateTime.now().isAfter(expiry);
}
