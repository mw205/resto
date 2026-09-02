import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resto_app/features/cart/data/models/cart_item_model.dart';
import 'package:resto_app/features/orders/data/models/order_model.dart';
import 'package:resto_app/features/orders/data/repositories/order_repository.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _repository;

  OrderCubit(this._repository) : super(const OrderState()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    emit(state.copyWith(status: OrderStateStatus.loading, errorMessage: null));
    try {
      final orders = await _repository.getOrders();
      emit(state.copyWith(status: OrderStateStatus.success, orders: orders));
    } catch (e) {
      emit(state.copyWith(
        status: OrderStateStatus.error,
        errorMessage: 'تعذر تحميل سجل الطلبات',
      ));
    }
  }

  Future<OrderModel?> placeOrder({
    required List<CartItemModel> items,
    required OrderType orderType,
    required String deliveryAddress,
    required String pickupBranch,
    required String customerPhone,
    String? customerNotes,
    double discount = 0.0,
  }) async {
    emit(state.copyWith(status: OrderStateStatus.loading, errorMessage: null));
    try {
      final newOrder = await _repository.placeOrder(
        items: items,
        orderType: orderType,
        deliveryAddress: deliveryAddress,
        pickupBranch: pickupBranch,
        customerPhone: customerPhone,
        customerNotes: customerNotes,
        discount: discount,
      );

      final updatedOrders = [newOrder, ...state.orders];
      emit(state.copyWith(
        status: OrderStateStatus.success,
        orders: updatedOrders,
        currentOrder: newOrder,
      ));
      return newOrder;
    } catch (e) {
      emit(state.copyWith(
        status: OrderStateStatus.error,
        errorMessage: 'تعذر تأكيد الطلب، يرجى المحاولة مرة أخرى',
      ));
      return null;
    }
  }

  Future<void> fetchOrderDetails(String orderId) async {
    emit(state.copyWith(status: OrderStateStatus.loading));
    try {
      final order = await _repository.getOrderById(orderId);
      if (order != null) {
        emit(state.copyWith(status: OrderStateStatus.success, currentOrder: order));
      } else {
        emit(state.copyWith(
          status: OrderStateStatus.error,
          errorMessage: 'الطلب غير موجود',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: OrderStateStatus.error,
        errorMessage: 'تعذر جلب تفاصيل الطلب',
      ));
    }
  }
}
