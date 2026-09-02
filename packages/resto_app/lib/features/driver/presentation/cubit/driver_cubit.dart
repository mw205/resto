import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../orders/data/repositories/order_repository.dart';
import 'driver_state.dart';

class DriverCubit extends Cubit<DriverState> {
  final OrderRepository _orderRepository;

  DriverCubit(this._orderRepository) : super(const DriverState()) {
    loadAssignedOrders();
  }

  Future<void> loadAssignedOrders() async {
    emit(state.copyWith(status: DriverStatus.loading, errorMessage: null));
    try {
      final orders = await _orderRepository.getDriverAssignedOrders();
      emit(state.copyWith(status: DriverStatus.success, assignedOrders: orders));
    } catch (e) {
      emit(state.copyWith(
        status: DriverStatus.error,
        errorMessage: 'تعذر جلب الطلبات المعينة',
      ));
    }
  }

  void selectOrder(OrderModel order) {
    emit(state.copyWith(selectedOrder: order));
  }

  Future<void> updateStatus(String orderId, OrderStatus newStatus) async {
    emit(state.copyWith(status: DriverStatus.loading));
    try {
      final updated = await _orderRepository.updateOrderStatus(orderId, newStatus);
      final currentList = List<OrderModel>.from(state.assignedOrders);
      final idx = currentList.indexWhere((o) => o.id == orderId);
      if (idx != -1) {
        currentList[idx] = updated;
      }
      emit(state.copyWith(
        status: DriverStatus.success,
        assignedOrders: currentList,
        selectedOrder: updated,
        successMessage: 'تم تحديث حالة الطلب إلى: ${newStatus.arabicTitle}',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DriverStatus.error,
        errorMessage: 'تعذر تحديث حالة الطلب',
      ));
    }
  }
}
