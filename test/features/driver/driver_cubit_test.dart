import 'package:flutter_test/flutter_test.dart';
import 'package:resto/core/network/mock_resto_api.dart';
import 'package:resto/features/driver/presentation/cubit/driver_cubit.dart';
import 'package:resto/features/driver/presentation/cubit/driver_state.dart';
import 'package:resto/features/orders/data/models/order_model.dart';
import 'package:resto/features/orders/data/repositories/order_repository.dart';

void main() {
  late MockRestoApi api;
  late OrderRepository orderRepository;
  late DriverCubit driverCubit;

  setUp(() {
    api = MockRestoApi();
    orderRepository = OrderRepositoryImpl(api);
    driverCubit = DriverCubit(orderRepository);
  });

  tearDown(() {
    driverCubit.close();
  });

  group('DriverCubit Tests', () {
    test('loads assigned delivery orders', () async {
      await driverCubit.loadAssignedOrders();

      expect(driverCubit.state.status, DriverStatus.success);
      expect(driverCubit.state.assignedOrders, isNotEmpty);
      expect(driverCubit.state.assignedOrders.every((o) => o.orderType == OrderType.delivery), true);
    });

    test('updates order status to delivered', () async {
      await driverCubit.loadAssignedOrders();
      final orderId = driverCubit.state.assignedOrders.first.id;

      await driverCubit.updateStatus(orderId, OrderStatus.delivered);

      expect(driverCubit.state.status, DriverStatus.success);
      final updated = driverCubit.state.assignedOrders.firstWhere((o) => o.id == orderId);
      expect(updated.status, OrderStatus.delivered);
      expect(driverCubit.state.successMessage, isNotNull);
    });
  });
}
