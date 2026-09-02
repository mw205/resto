class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'حدث خطأ في الخادم']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'حدث خطأ في الذاكرة المؤقتة']);
}

class AuthException implements Exception {
  final String message;
  AuthException([this.message = 'خطأ في المصادقة']);
}
