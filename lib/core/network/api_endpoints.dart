class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.resto.eg/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';

  // Menu
  static const String categories = '/categories';
  static const String products = '/products';
  static const String featuredProducts = '/products/featured';

  // Coupons
  static const String validateCoupon = '/coupons/validate';

  // Orders
  static const String orders = '/orders';
  static const String activeOrders = '/orders/active';
  static const String orderDetails = '/orders/{id}';
  static const String orderTracking = '/orders/{id}/tracking';

  // Driver
  static const String driverOrders = '/driver/orders';
  static const String driverUpdateStatus = '/driver/orders/{id}/status';

  // Feedback & Complaints
  static const String feedback = '/feedback';
  static const String complaints = '/complaints';

  // Notifications
  static const String notifications = '/notifications';
}
