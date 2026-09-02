import 'package:equatable/equatable.dart';
import '../../../orders/data/models/order_model.dart';

enum DriverStatus { initial, loading, success, error }

class DriverState extends Equatable {
  final DriverStatus status;
  final List<OrderModel> assignedOrders;
  final OrderModel? selectedOrder;
  final String? successMessage;
  final String? errorMessage;

  const DriverState({
    this.status = DriverStatus.initial,
    this.assignedOrders = const [],
    this.selectedOrder,
    this.successMessage,
    this.errorMessage,
  });

  List<OrderModel> get activeAssignedOrders => assignedOrders
      .where((o) => o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled)
      .toList();

  List<OrderModel> get completedOrders =>
      assignedOrders.where((o) => o.status == OrderStatus.delivered).toList();

  DriverState copyWith({
    DriverStatus? status,
    List<OrderModel>? assignedOrders,
    OrderModel? selectedOrder,
    String? successMessage,
    String? errorMessage,
  }) {
    return DriverState(
      status: status ?? this.status,
      assignedOrders: assignedOrders ?? this.assignedOrders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        assignedOrders,
        selectedOrder,
        successMessage,
        errorMessage,
      ];
}
