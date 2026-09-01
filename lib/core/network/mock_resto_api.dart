import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/cart/data/models/cart_item_model.dart';
import '../../features/cart/data/models/coupon_model.dart';
import '../../features/feedback/data/models/feedback_model.dart';
import '../../features/menu/data/models/category_model.dart';
import '../../features/menu/data/models/product_model.dart';
import '../../features/notifications/data/models/notification_model.dart';
import '../../features/orders/data/models/order_model.dart';
import '../constants/app_assets.dart';

class MockRestoApi {
  static final MockRestoApi _instance = MockRestoApi._internal();
  factory MockRestoApi() => _instance;

  final _uuid = const Uuid();

  MockRestoApi._internal() {
    _initData();
  }

  UserModel? _currentUser;
  final List<CategoryModel> _categories = [];
  final List<ProductModel> _products = [];
  final List<CouponModel> _coupons = [];
  final List<OrderModel> _orders = [];
  final List<NotificationModel> _notifications = [];
  final List<ComplaintModel> _complaints = [];

  void _initData() {
    // Current Default User
    _currentUser = const UserModel(
      id: 'usr_001',
      name: 'محمد فوزي',
      email: 'mohamed@resto.eg',
      phone: '01012345678',
      role: UserRole.customer,
      token: 'jwt_token_sample_customer_123',
      savedAddresses: [
        'القاهرة - مصر الجديدة - شارع الثورة عمارة 14 الدور 3',
        'التجمع الخامس - حي النرجس عمارة 50 شقة 4',
      ],
    );

    // Categories
    _categories.addAll([
      const CategoryModel(
        id: 'cat_grills',
        name: 'مشويات وفحم',
        icon: '🍖',
        imageUrl: AppAssets.grillsImg,
      ),
      const CategoryModel(
        id: 'cat_koshary',
        name: 'كشري وطواجن',
        icon: '🍲',
        imageUrl: AppAssets.kosharyImg,
      ),
      const CategoryModel(
        id: 'cat_main',
        name: 'أطباق رئيسية ومحاشي',
        icon: '🥘',
        imageUrl: AppAssets.molokhiaImg,
      ),
      const CategoryModel(
        id: 'cat_sandwiches',
        name: 'سندوتشات وحواوشي',
        icon: '🥪',
        imageUrl: AppAssets.hawawshiImg,
      ),
      const CategoryModel(
        id: 'cat_desserts',
        name: 'حلويات شرقية',
        icon: '🍮',
        imageUrl: AppAssets.ummAliImg,
      ),
      const CategoryModel(
        id: 'cat_drinks',
        name: 'عصائر ومشروبات',
        icon: '🥤',
        imageUrl: AppAssets.drinksImg,
      ),
    ]);

    // Products
    _products.addAll([
      const ProductModel(
        id: 'prod_001',
        name: 'كشري مصري ملوكي',
        description:
            'أرز وعدس بجبة ومكرونة مشكلة مع حمص الشام، تقلية بصل مقرمشة جداً، وصلصة طماطم حارة ودقة ثوم وخل على أصولها.',
        price: 45.0,
        imageUrl: AppAssets.kosharyImg,
        categoryId: 'cat_koshary',
        categoryName: 'كشري وطواجن',
        rating: 4.9,
        reviewsCount: 310,
        calories: 580,
        preparationTimeMinutes: 15,
        ingredients: ['أرز مصري', 'عدس بني', 'مكرونة', 'حمص', 'بصل مقرمش', 'صلصة طماطم سرية', 'دقة ثوم وخل'],
        isFeatured: true,
      ),
      const ProductModel(
        id: 'prod_002',
        name: 'ملوخية خضراء مع فراخ محمرة',
        description:
            'ملوخية طازة خضراء مخروطة بطشة الثوم والكزبرة الجافة، تقدم مع نصف دجاجة بلدي محمرة في السمن الفلاحي وأرز بالشعرية.',
        price: 125.0,
        imageUrl: AppAssets.molokhiaImg,
        categoryId: 'cat_main',
        categoryName: 'أطباق رئيسية ومحاشي',
        rating: 5.0,
        reviewsCount: 245,
        calories: 680,
        preparationTimeMinutes: 25,
        ingredients: ['ملوخية خضراء', 'دجاج بلدي', 'أرز بالشعرية', 'ثوم بلدي', 'كزبرة ناشفة', 'سمن بلدي'],
        isFeatured: true,
      ),
      const ProductModel(
        id: 'prod_003',
        name: 'مشويات ريستو مشكلة فاخرة',
        description:
            'تشكيلة ملوكية من كباب الضاني، كفتة حاتي متبلة، شيش طاووق، وطرب مشوي على الفحم الحجري. تقدم مع طحينة وسلطة بلدي وعيش سخن.',
        price: 240.0,
        imageUrl: AppAssets.grillsImg,
        categoryId: 'cat_grills',
        categoryName: 'مشويات وفحم',
        rating: 4.9,
        reviewsCount: 418,
        calories: 850,
        preparationTimeMinutes: 30,
        ingredients: ['كباب ضاني', 'كفتة حاتي', 'شيش طاووق', 'طرب', 'سلطة طحينة', 'سلطة بلدي', 'خبز بلدي'],
        isFeatured: true,
      ),
      const ProductModel(
        id: 'prod_004',
        name: 'طاجن عكاوي بالبصل المكرمل',
        description:
            'قطع عكاوي بتلو ذائبة في الفخار مع بصل مكرمل بصوص البهارات المصرية الأصيلة ولمسة قرفة وجوزة الطيب.',
        price: 195.0,
        imageUrl: AppAssets.tagineImg,
        categoryId: 'cat_koshary',
        categoryName: 'كشري وطواجن',
        rating: 4.8,
        reviewsCount: 160,
        calories: 720,
        preparationTimeMinutes: 35,
        ingredients: ['عكاوي بتلو', 'بصل مكرمل', 'طماطم طازجة', 'بهارات مشكلة', 'سمن بلدي'],
        isFeatured: true,
      ),
      const ProductModel(
        id: 'prod_005',
        name: 'حواوشي بلدي على الفحم بالجبنة',
        description:
            'لحمة بلدي مفرومة بالخلطة الخاصة والفلفل الأخضر في رغيف بلدي مقرمش على الفحم مع طبقة غنية من الموتزاريلا السايحة.',
        price: 65.0,
        imageUrl: AppAssets.hawawshiImg,
        categoryId: 'cat_sandwiches',
        categoryName: 'سندوتشات وحواوشي',
        rating: 4.7,
        reviewsCount: 290,
        calories: 520,
        preparationTimeMinutes: 20,
        ingredients: ['لحم بقري مفروم', 'عيش بلدي طازج', 'جبنة موتزاريلا', 'فلفل حامي', 'توابل حواوشي'],
        isFeatured: false,
      ),
      const ProductModel(
        id: 'prod_006',
        name: 'صينية محشي مشكل مصري',
        description:
            'مكس محاشي مشكلة (ورق عنب بدبس الرمان، كوسة، باذنجان أبيض وأسود، فلفل رومي) بتسبيكة ريستو الخاصة.',
        price: 85.0,
        imageUrl: AppAssets.mahshiImg,
        categoryId: 'cat_main',
        categoryName: 'أطباق رئيسية ومحاشي',
        rating: 4.8,
        reviewsCount: 175,
        calories: 490,
        preparationTimeMinutes: 25,
        ingredients: ['ورق عنب', 'كوسة', 'باذنجان', 'فلفل', 'أرز مصري', 'صلصة طماطم', 'شبت وبقدونس'],
        isFeatured: false,
      ),
      const ProductModel(
        id: 'prod_007',
        name: 'شاورما لحم عربي مصري',
        description:
            'شاورما لحم كندوز مع شرائح البصل والبقدونس والطماطم وصوص الطحينة المميز في خبز كيزر طازج مع مخلل وبطاطس.',
        price: 75.0,
        imageUrl: AppAssets.shawarmaImg,
        categoryId: 'cat_sandwiches',
        categoryName: 'سندوتشات وحواوشي',
        rating: 4.6,
        reviewsCount: 130,
        calories: 460,
        preparationTimeMinutes: 15,
        ingredients: ['لحم كندوز', 'صوص طحينة', 'بقدونس وبصل', 'عيش كيزر', 'بطاطس محمرة'],
        isFeatured: false,
      ),
      const ProductModel(
        id: 'prod_008',
        name: 'كبدة إسكندراني حامية',
        description:
            'كبدة بتلو طازة مقطعة عصافيري متبلة بالثوم المفروم والخل والليمون والكمون مع فلفل رومي وفلفل حراق ناري.',
        price: 60.0,
        imageUrl: AppAssets.liverImg,
        categoryId: 'cat_sandwiches',
        categoryName: 'سندوتشات وحواوشي',
        rating: 4.9,
        reviewsCount: 220,
        calories: 410,
        preparationTimeMinutes: 15,
        ingredients: ['كبدة بتلو طازة', 'ثوم مفروم', 'فلفل حامي', 'ليمون وخل', 'كمون وكزبرة'],
        isFeatured: false,
      ),
      const ProductModel(
        id: 'prod_009',
        name: 'طاجن أم علي بالقشطة البلدي والمكسرات',
        description:
            'رقاق مخبوز مسقي بالحليب المكثف الساخن والكريمة، ومغطى بطبقة سخية من القشطة البلدي والمكسرات المحمصة (فستق وبندق ولوز).',
        price: 55.0,
        imageUrl: AppAssets.ummAliImg,
        categoryId: 'cat_desserts',
        categoryName: 'حلويات شرقية',
        rating: 5.0,
        reviewsCount: 380,
        calories: 540,
        preparationTimeMinutes: 15,
        ingredients: ['عجينة ملفيه', 'حليب كامل الدسم', 'قشطة فلاحي', 'فستق ولوز وبندق', 'زبيب وجوز هند'],
        isFeatured: true,
      ),
      const ProductModel(
        id: 'prod_010',
        name: 'طاجن أرز باللبن فرن مكرمل',
        description:
            'أرز باللبن غني بالحليب الطبيعي والقشطة والمستكة مع وش مكرمل بالفرن ورشة قرفة.',
        price: 40.0,
        imageUrl: AppAssets.ricePuddingImg,
        categoryId: 'cat_desserts',
        categoryName: 'حلويات شرقية',
        rating: 4.8,
        reviewsCount: 190,
        calories: 380,
        preparationTimeMinutes: 10,
        ingredients: ['حليب طبيعي', 'أرز مصري', 'قشطة بلدي', 'سكر', 'مستكة وفانيليا'],
        isFeatured: false,
      ),
      const ProductModel(
        id: 'prod_011',
        name: 'سوبيا ريستو المثلجة بالمكسرات',
        description:
            'مشروب السوبيا المصري الشهير بجوز الهند والحليب المركز والمكسرات المجروشة، يقدم مثلجاً ومنعشاً.',
        price: 25.0,
        imageUrl: AppAssets.drinksImg,
        categoryId: 'cat_drinks',
        categoryName: 'عصائر ومشروبات',
        rating: 4.7,
        reviewsCount: 150,
        calories: 220,
        preparationTimeMinutes: 5,
        ingredients: ['حليب طبيعي', 'بودرة سوبيا أصيلة', 'جوز هند', 'مكسرات مجروشة'],
        isFeatured: false,
      ),
    ]);

    // Coupons
    _coupons.addAll([
      CouponModel(
        code: 'RESTO20',
        discountPercentage: 20.0,
        maxDiscount: 50.0,
        minOrderValue: 100.0,
        expiryDate: DateTime.now().add(const Duration(days: 60)),
      ),
      CouponModel(
        code: 'WELCOME',
        discountPercentage: 15.0,
        maxDiscount: 40.0,
        minOrderValue: 70.0,
        expiryDate: DateTime.now().add(const Duration(days: 90)),
      ),
      CouponModel(
        code: 'MASHWEYAT10',
        isFixed: true,
        fixedDiscountAmount: 20.0,
        minOrderValue: 150.0,
        expiryDate: DateTime.now().add(const Duration(days: 30)),
      ),
    ]);

    // Sample Orders
    _orders.addAll([
      OrderModel(
        id: 'ord_101',
        orderNumber: 'EG-9481',
        items: [
          CartItemModel(product: _products[0], quantity: 2, specialInstructions: 'بدون شطة زيادة'),
          CartItemModel(product: _products[8], quantity: 1, specialInstructions: 'زيادة مكسرات'),
        ],
        subtotal: 145.0,
        discount: 20.0,
        deliveryFee: 25.0,
        total: 150.0,
        status: OrderStatus.onTheWay,
        orderType: OrderType.delivery,
        deliveryAddress: 'القاهرة - مصر الجديدة - شارع الثورة عمارة 14 الدور 3',
        customerName: 'محمد فوزي',
        customerPhone: '01012345678',
        driverId: 'drv_001',
        driverName: 'كابتن هاني سعيد',
        driverPhone: '01198765432',
        createdAt: DateTime.now().subtract(const Duration(minutes: 22)),
      ),
      OrderModel(
        id: 'ord_102',
        orderNumber: 'EG-9230',
        items: [
          CartItemModel(product: _products[2], quantity: 1, specialInstructions: 'طحينة زيادة'),
        ],
        subtotal: 240.0,
        discount: 0.0,
        deliveryFee: 25.0,
        total: 265.0,
        status: OrderStatus.delivered,
        orderType: OrderType.delivery,
        deliveryAddress: 'القاهرة - التجمع الخامس - حي النرجس عمارة 50 شقة 4',
        customerName: 'محمد فوزي',
        customerPhone: '01012345678',
        driverId: 'drv_001',
        driverName: 'كابتن هاني سعيد',
        driverPhone: '01198765432',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        deliveredAt: DateTime.now().subtract(const Duration(days: 2, hours: -1)),
        rating: 5.0,
        reviewComment: 'الأكل وصل سخن وطازة جداً ومستوى المشويات ممتاز!',
      ),
      OrderModel(
        id: 'ord_103',
        orderNumber: 'EG-8820',
        items: [
          CartItemModel(product: _products[1], quantity: 1),
          CartItemModel(product: _products[4], quantity: 2),
        ],
        subtotal: 255.0,
        discount: 30.0,
        deliveryFee: 0.0,
        total: 225.0,
        status: OrderStatus.delivered,
        orderType: OrderType.takeaway,
        pickupBranch: 'فرع التجمع الخامس - مول بوينت 90',
        customerName: 'محمد فوزي',
        customerPhone: '01012345678',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        deliveredAt: DateTime.now().subtract(const Duration(days: 5, hours: -1)),
      ),
    ]);

    // Notifications
    _notifications.addAll([
      NotificationModel(
        id: 'notif_01',
        title: 'طلبك في الطريق إليك! 🛵',
        body: 'كابتن هاني سعيد استلم طلبك رقم EG-9481 وهو في الطريق لعنوانك الآن.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        targetOrderId: 'ord_101',
      ),
      NotificationModel(
        id: 'notif_02',
        title: 'عرض المشويات الأسبوعي 🔥',
        body: 'استمتع بخصم 20% بكود RESTO20 على كل أصناف المشويات على الفحم.',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        type: 'promo',
      ),
    ]);
  }

  // Auth Operations
  Future<UserModel> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (email.contains('driver')) {
      _currentUser = const UserModel(
        id: 'drv_001',
        name: 'كابتن هاني سعيد',
        email: 'driver@resto.eg',
        phone: '01198765432',
        role: UserRole.driver,
        token: 'jwt_token_sample_driver_456',
      );
    } else {
      _currentUser = UserModel(
        id: 'usr_${_uuid.v4().substring(0, 6)}',
        name: email.split('@').first,
        email: email,
        phone: '01012345678',
        role: UserRole.customer,
        token: 'jwt_token_sample_customer_${_uuid.v4()}',
        savedAddresses: const [
          'القاهرة - مصر الجديدة - شارع الثورة عمارة 14 الدور 3',
        ],
      );
    }
    return _currentUser!;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = UserModel(
      id: 'usr_${_uuid.v4().substring(0, 6)}',
      name: name,
      email: email,
      phone: phone,
      role: UserRole.customer,
      token: 'jwt_token_sample_customer_${_uuid.v4()}',
      savedAddresses: const ['القاهرة - مصر الجديدة - شارع الثورة'],
    );
    return _currentUser!;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  UserModel? getCurrentUser() => _currentUser;

  void switchToRole(UserRole role) {
    if (role == UserRole.driver) {
      _currentUser = const UserModel(
        id: 'drv_001',
        name: 'كابتن هاني سعيد',
        email: 'driver@resto.eg',
        phone: '01198765432',
        role: UserRole.driver,
        token: 'jwt_token_sample_driver_456',
      );
    } else {
      _currentUser = const UserModel(
        id: 'usr_001',
        name: 'محمد فوزي',
        email: 'mohamed@resto.eg',
        phone: '01012345678',
        role: UserRole.customer,
        token: 'jwt_token_sample_customer_123',
        savedAddresses: [
          'القاهرة - مصر الجديدة - شارع الثورة عمارة 14 الدور 3',
        ],
      );
    }
  }

  // Menu Operations
  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_categories);
  }

  Future<List<ProductModel>> getProducts({String? categoryId, String? search}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var list = _products;
    if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') {
      list = list.where((p) => p.categoryId == categoryId).toList();
    }
    if (search != null && search.trim().isNotEmpty) {
      final query = search.trim().toLowerCase();
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(query) ||
              p.description.toLowerCase().contains(query) ||
              p.categoryName.toLowerCase().contains(query))
          .toList();
    }
    return list;
  }

  Future<ProductModel?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // Coupon
  Future<CouponModel?> validateCoupon(String code) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      return _coupons.firstWhere((c) => c.code.toUpperCase() == code.trim().toUpperCase());
    } catch (_) {
      return null;
    }
  }

  // Order Operations
  Future<OrderModel> placeOrder({
    required List<CartItemModel> items,
    required OrderType orderType,
    required String deliveryAddress,
    required String pickupBranch,
    required String customerPhone,
    String? customerNotes,
    double discount = 0.0,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final subtotal = items.fold<double>(0, (sum, item) => sum + item.totalPrice);
    final deliveryFee = orderType == OrderType.delivery ? 25.0 : 0.0;
    final total = (subtotal - discount + deliveryFee).clamp(0.0, double.infinity);

    final newOrder = OrderModel(
      id: 'ord_${_uuid.v4().substring(0, 6)}',
      orderNumber: 'EG-${(1000 + _orders.length + 1)}',
      items: items,
      orderType: orderType,
      status: OrderStatus.received,
      subtotal: subtotal,
      discount: discount,
      deliveryFee: deliveryFee,
      total: total,
      deliveryAddress: deliveryAddress,
      pickupBranch: pickupBranch,
      customerName: _currentUser?.name ?? 'عميل ريستو',
      customerPhone: customerPhone,
      customerNotes: customerNotes,
      driverId: 'drv_001',
      driverName: 'كابتن هاني سعيد',
      driverPhone: '01198765432',
      createdAt: DateTime.now(),
    );

    _orders.insert(0, newOrder);

    _notifications.insert(
      0,
      NotificationModel(
        id: _uuid.v4(),
        title: 'تم استلام طلبك ${newOrder.orderNumber} 🎉',
        body: 'المطبخ بدأ في تحضير أشهى المأكولات المصرية لطلبك.',
        createdAt: DateTime.now(),
        targetOrderId: newOrder.id,
      ),
    );

    return newOrder;
  }

  Future<List<OrderModel>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_orders);
  }

  Future<OrderModel?> getOrderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  // Driver Operations
  Future<List<OrderModel>> getDriverAssignedOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _orders
        .where((o) =>
            o.orderType == OrderType.delivery &&
            o.status != OrderStatus.cancelled)
        .toList();
  }

  Future<OrderModel> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index == -1) {
      throw Exception('Order not found');
    }
    final updated = _orders[index].copyWith(
      status: newStatus,
      deliveredAt: newStatus == OrderStatus.delivered ? DateTime.now() : null,
    );
    _orders[index] = updated;

    String notifBody = 'تم تحديث حالة طلبك إلى: ${newStatus.arabicTitle}';
    if (newStatus == OrderStatus.onTheWay) {
      notifBody = 'الكابتن استلم طلبك وهو في الطريق لعنوانك الآن 🛵';
    } else if (newStatus == OrderStatus.delivered) {
      notifBody = 'تم تسليم طلبك بنجاح. بالهنا والشفا! ❤️';
    }

    _notifications.insert(
      0,
      NotificationModel(
        id: _uuid.v4(),
        title: 'تحديث حالة الطلب ${updated.orderNumber}',
        body: notifBody,
        createdAt: DateTime.now(),
        targetOrderId: updated.id,
      ),
    );

    return updated;
  }

  // Feedback & Complaints
  Future<void> submitFeedback(OrderFeedbackModel feedback) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final index = _orders.indexWhere((o) => o.id == feedback.orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(
        rating: feedback.rating,
        reviewComment: feedback.comment,
      );
    }
  }

  Future<void> submitComplaint(ComplaintModel complaint) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _complaints.insert(0, complaint);
  }

  // Notifications
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_notifications);
  }

  Future<void> markNotificationsAsRead() async {
    await Future.delayed(const Duration(milliseconds: 200));
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }
}
