import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/theme/theme_cubit.dart';
import '../network/dio_client.dart';
import '../network/mock_resto_api.dart';

import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

import '../../features/menu/data/repositories/menu_repository.dart';
import '../../features/menu/presentation/cubit/menu_cubit.dart';

import '../../features/cart/presentation/cubit/cart_cubit.dart';

import '../../features/orders/data/repositories/order_repository.dart';
import '../../features/orders/presentation/cubit/order_cubit.dart';
import '../../features/orders/presentation/cubit/order_tracking_cubit.dart';

import '../../features/driver/presentation/cubit/driver_cubit.dart';
import '../../features/feedback/presentation/cubit/feedback_cubit.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // External & Storage
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Network & Mock API
  final mockApi = MockRestoApi();
  sl.registerLazySingleton<MockRestoApi>(() => mockApi);

  final dioClient = DioClient(sharedPreferences: sharedPreferences);
  sl.registerLazySingleton<DioClient>(() => dioClient);

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<MockRestoApi>(), sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(sl<MockRestoApi>()),
  );
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(sl<MockRestoApi>()),
  );

  // Cubits / Blocs
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl<SharedPreferences>()));
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(sl<AuthRepository>()));
  sl.registerFactory<MenuCubit>(() => MenuCubit(sl<MenuRepository>()));
  sl.registerLazySingleton<CartCubit>(() => CartCubit(sl<MockRestoApi>()));
  sl.registerFactory<OrderCubit>(() => OrderCubit(sl<OrderRepository>()));
  sl.registerFactory<OrderTrackingCubit>(() => OrderTrackingCubit(sl<OrderRepository>()));
  sl.registerFactory<DriverCubit>(() => DriverCubit(sl<OrderRepository>()));
  sl.registerFactory<FeedbackCubit>(() => FeedbackCubit(sl<MockRestoApi>()));
  sl.registerFactory<NotificationsCubit>(() => NotificationsCubit(sl<MockRestoApi>()));
}
