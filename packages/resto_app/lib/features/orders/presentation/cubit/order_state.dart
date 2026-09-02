import 'package:equatable/equatable.dart';
import '../../data/models/order_model.dart';

enum OrderStateStatus { initial, loading, success, error }

class OrderState extends Equatable {
  final OrderStateStatus status;
  final List<OrderModel> orders;
  final OrderModel? currentOrder;
  final String? errorMessage;

  const OrderState({
    this.status = OrderStateStatus.initial,
    this.orders = const [],
    this.currentOrder,
    this.errorMessage,
  });

  List<OrderModel> get activeOrders => orders
      .where((o) =>
          o.status == OrderStatus.received ||
          o.status == OrderStatus.preparing ||
          o.status == OrderStatus.onTheWay ||
          o.status == OrderStatus.readyForPickup)
      .toList();

  List<OrderModel> get pastOrders => orders
      .where((o) => o.status == OrderStatus.delivered || o.status == OrderStatus.cancelled)
      .toList();

  OrderState copyWith({
    OrderStateStatus? status,
    List<OrderModel>? orders,
    OrderModel? currentOrder,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      currentOrder: currentOrder ?? this.currentOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, orders, currentOrder, errorMessage];
}
