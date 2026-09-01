import 'package:flutter_test/flutter_test.dart';
import 'package:resto/core/network/mock_resto_api.dart';
import 'package:resto/features/orders/data/models/order_model.dart';
import 'package:resto/features/orders/data/repositories/order_repository.dart';
import 'package:resto/features/orders/presentation/cubit/order_tracking_cubit.dart';

void main() {
  late MockRestoApi api;
  late OrderRepository orderRepository;
  late OrderTrackingCubit trackingCubit;

  setUp(() {
    api = MockRestoApi();
    orderRepository = OrderRepositoryImpl(api);
    trackingCubit = OrderTrackingCubit(orderRepository);
  });

  tearDown(() {
    trackingCubit.close();
  });

  group('OrderTrackingCubit Tests', () {
    test('trackOrder loads active delivery order with 4 tracking steps', () async {
      await trackingCubit.trackOrder('ord_101');

      expect(trackingCubit.state.order, isNotNull);
      expect(trackingCubit.state.order?.id, 'ord_101');
      expect(trackingCubit.state.steps.length, 4);
      expect(trackingCubit.state.steps[0].status, OrderStatus.received);
      expect(trackingCubit.state.steps[1].status, OrderStatus.preparing);
      expect(trackingCubit.state.steps[2].status, OrderStatus.onTheWay);
      expect(trackingCubit.state.steps[3].status, OrderStatus.delivered);

      // Current is onTheWay
      expect(trackingCubit.state.steps[2].isCurrent, true);
      expect(trackingCubit.state.steps[2].isCompleted, true);
      expect(trackingCubit.state.steps[3].isCompleted, false);
    });

    test('trackOrder loads takeaway order with 3 tracking steps', () async {
      await trackingCubit.trackOrder('ord_103');

      expect(trackingCubit.state.order, isNotNull);
      expect(trackingCubit.state.order?.orderType, OrderType.takeaway);
      expect(trackingCubit.state.steps.length, 3);
      expect(trackingCubit.state.steps[2].status, OrderStatus.readyForPickup);
    });
  });
}
