import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_endpoints.dart';
import 'auth_interceptor.dart';
import 'cache_interceptor.dart';
import 'logging_interceptor.dart';

class DioClient {
  final Dio dio;
  final CacheInterceptor cacheInterceptor;

  DioClient._({required this.dio, required this.cacheInterceptor});

  factory DioClient({required SharedPreferences sharedPreferences}) {
    final baseOptions = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Accept-Language': 'ar-EG',
      },
    );

    final dio = Dio(baseOptions);
    final cache = CacheInterceptor();

    dio.interceptors.addAll([
      AuthInterceptor(sharedPreferences),
      cache,
      LoggingInterceptor(),
    ]);

    return DioClient._(dio: dio, cacheInterceptor: cache);
  }
}
