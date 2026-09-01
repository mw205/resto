import 'package:resto/core/network/mock_resto_api.dart';
import 'package:resto/features/cart/data/models/cart_item_model.dart';
import 'package:resto/features/orders/data/models/order_model.dart';

abstract class OrderRepository {
  Future<OrderModel> placeOrder({
    required List<CartItemModel> items,
    required OrderType orderType,
    required String deliveryAddress,
    required String pickupBranch,
    required String customerPhone,
    String? customerNotes,
    double discount = 0.0,
  });
  Future<List<OrderModel>> getOrders();
  Future<OrderModel?> getOrderById(String id);
  Future<List<OrderModel>> getDriverAssignedOrders();
  Future<OrderModel> updateOrderStatus(String orderId, OrderStatus newStatus);
}

class OrderRepositoryImpl implements OrderRepository {
  final MockRestoApi _api;

  OrderRepositoryImpl(this._api);

  @override
  Future<OrderModel> placeOrder({
    required List<CartItemModel> items,
    required OrderType orderType,
    required String deliveryAddress,
    required String pickupBranch,
    required String customerPhone,
    String? customerNotes,
    double discount = 0.0,
  }) {
    return _api.placeOrder(
      items: items,
      orderType: orderType,
      deliveryAddress: deliveryAddress,
      pickupBranch: pickupBranch,
      customerPhone: customerPhone,
      customerNotes: customerNotes,
      discount: discount,
    );
  }

  @override
  Future<List<OrderModel>> getOrders() => _api.getOrders();

  @override
  Future<OrderModel?> getOrderById(String id) => _api.getOrderById(id);

  @override
  Future<List<OrderModel>> getDriverAssignedOrders() => _api.getDriverAssignedOrders();

  @override
  Future<OrderModel> updateOrderStatus(String orderId, OrderStatus newStatus) =>
      _api.updateOrderStatus(orderId, newStatus);
}
