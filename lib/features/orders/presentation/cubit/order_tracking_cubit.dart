import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';
import 'order_tracking_state.dart';

class OrderTrackingCubit extends Cubit<OrderTrackingState> {
  final OrderRepository _repository;

  OrderTrackingCubit(this._repository) : super(const OrderTrackingState());

  Future<void> trackOrder(String orderId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final order = await _repository.getOrderById(orderId);
      if (order != null) {
        final steps = _generateSteps(order);
        emit(state.copyWith(
          isLoading: false,
          order: order,
          steps: steps,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'لم يتم العثور على الطلب',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'تعذر تحميل بيانات التتبع',
      ));
    }
  }

  List<TrackingStep> _generateSteps(OrderModel order) {
    if (order.orderType == OrderType.takeaway) {
      final statuses = [
        OrderStatus.received,
        OrderStatus.preparing,
        OrderStatus.readyForPickup,
      ];
      final currentIdx = statuses.indexOf(order.status);

      return [
        TrackingStep(
          status: OrderStatus.received,
          title: 'تم استلام الطلب',
          description: 'تم تأكيد طلبك وتجهيز مكونات الأكلات المصرية الأصيلة',
          isCompleted: currentIdx >= 0,
          isCurrent: order.status == OrderStatus.received,
        ),
        TrackingStep(
          status: OrderStatus.preparing,
          title: 'قيد التحضير في المطبخ',
          description: 'الشيف بيجهز طلبك بكل حب واهتمام',
          isCompleted: currentIdx >= 1,
          isCurrent: order.status == OrderStatus.preparing,
        ),
        TrackingStep(
          status: OrderStatus.readyForPickup,
          title: 'جاهز للاستلام من الفرع',
          description: 'أكلك ساخن وجاهز في ${order.pickupBranch}',
          isCompleted: currentIdx >= 2,
          isCurrent: order.status == OrderStatus.readyForPickup,
        ),
      ];
    }

    final statuses = [
      OrderStatus.received,
      OrderStatus.preparing,
      OrderStatus.onTheWay,
      OrderStatus.delivered,
    ];
    final currentIdx = statuses.indexOf(order.status);

    return [
      TrackingStep(
        status: OrderStatus.received,
        title: 'تم استلام الطلب',
        description: 'تم تأكيد طلبك وإرساله للمطبخ فوراً',
        isCompleted: currentIdx >= 0,
        isCurrent: order.status == OrderStatus.received,
      ),
      TrackingStep(
        status: OrderStatus.preparing,
        title: 'قيد التحضير في المطبخ',
        description: 'الشيف ريستو بيجهز طلبك على أصوله',
        isCompleted: currentIdx >= 1,
        isCurrent: order.status == OrderStatus.preparing,
      ),
      TrackingStep(
        status: OrderStatus.onTheWay,
        title: 'في الطريق إليك مع الكابتن',
        description: order.driverName != null
            ? '${order.driverName} في طريقه لعنوانك الآن'
            : 'الكابتن استلم الطلب وهو في الطريق',
        isCompleted: currentIdx >= 2,
        isCurrent: order.status == OrderStatus.onTheWay,
      ),
      TrackingStep(
        status: OrderStatus.delivered,
        title: 'تم التسليم بنجاح',
        description: 'بالهنا والشفا! نتمنى أن تنال الوجبة إعجابكم',
        isCompleted: currentIdx >= 3,
        isCurrent: order.status == OrderStatus.delivered,
      ),
    ];
  }
}
