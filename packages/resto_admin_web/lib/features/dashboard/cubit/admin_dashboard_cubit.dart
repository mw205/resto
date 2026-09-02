import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resto_core/resto_core.dart';
import 'package:equatable/equatable.dart';

class AdminDashboardState extends Equatable {
  final bool isLoading;
  final List<OrderModel> orders;
  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final List<ComplaintModel> complaints;
  final int selectedNavIndex;
  final String orderFilter; // 'all', 'active', 'completed'

  const AdminDashboardState({
    this.isLoading = true,
    this.orders = const [],
    this.products = const [],
    this.categories = const [],
    this.complaints = const [],
    this.selectedNavIndex = 0,
    this.orderFilter = 'all',
  });

  // Computed Metrics
  double get todayRevenue {
    return orders
        .where((o) => o.status != OrderStatus.cancelled)
        .fold(0.0, (sum, o) => sum + o.total);
  }

  int get pendingOrdersCount =>
      orders.where((o) => o.status == OrderStatus.received || o.status == OrderStatus.preparing).length;

  int get outForDeliveryCount =>
      orders.where((o) => o.status == OrderStatus.onTheWay).length;

  int get deliveredCount =>
      orders.where((o) => o.status == OrderStatus.delivered).length;

  List<OrderModel> get filteredOrders {
    if (orderFilter == 'active') {
      return orders.where((o) => o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled).toList();
    } else if (orderFilter == 'completed') {
      return orders.where((o) => o.status == OrderStatus.delivered).toList();
    }
    return orders;
  }

  AdminDashboardState copyWith({
    bool? isLoading,
    List<OrderModel>? orders,
    List<ProductModel>? products,
    List<CategoryModel>? categories,
    List<ComplaintModel>? complaints,
    int? selectedNavIndex,
    String? orderFilter,
  }) {
    return AdminDashboardState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      complaints: complaints ?? this.complaints,
      selectedNavIndex: selectedNavIndex ?? this.selectedNavIndex,
      orderFilter: orderFilter ?? this.orderFilter,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        orders,
        products,
        categories,
        complaints,
        selectedNavIndex,
        orderFilter,
      ];
}

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  final MockRestoApi _api = MockRestoApi();

  AdminDashboardCubit() : super(const AdminDashboardState()) {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final orders = await _api.getOrders();
      final products = await _api.getProducts();
      final categories = await _api.getCategories();
      final complaints = await _api.getComplaints();

      emit(state.copyWith(
        isLoading: false,
        orders: orders,
        products: products,
        categories: categories,
        complaints: complaints,
      ));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void selectNavIndex(int index) {
    emit(state.copyWith(selectedNavIndex: index));
  }

  void setOrderFilter(String filter) {
    emit(state.copyWith(orderFilter: filter));
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    await _api.updateOrderStatus(orderId, newStatus);
    final updatedOrders = await _api.getOrders();
    emit(state.copyWith(orders: updatedOrders));
  }

  Future<void> toggleProductAvailability(String productId) async {
    final updatedProducts = state.products.map((p) {
      if (p.id == productId) {
        return p.copyWith(isAvailable: !p.isAvailable);
      }
      return p;
    }).toList();
    emit(state.copyWith(products: updatedProducts));
  }

  Future<void> addProduct(ProductModel product) async {
    await _api.addProduct(product);
    final updatedProducts = await _api.getProducts();
    emit(state.copyWith(products: updatedProducts));
  }
}
