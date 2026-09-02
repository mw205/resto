import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/di/service_locator.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_cubit.dart';

import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/menu/presentation/cubit/menu_cubit.dart';
import '../features/cart/presentation/cubit/cart_cubit.dart';
import '../features/orders/presentation/cubit/order_cubit.dart';
import '../features/orders/presentation/cubit/order_tracking_cubit.dart';
import '../features/driver/presentation/cubit/driver_cubit.dart';
import '../features/feedback/presentation/cubit/feedback_cubit.dart';
import '../features/notifications/presentation/cubit/notifications_cubit.dart';

class RestoApp extends StatefulWidget {
  const RestoApp({super.key});

  @override
  State<RestoApp> createState() => _RestoAppState();
}

class _RestoAppState extends State<RestoApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter(sl<AuthCubit>());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: sl<ThemeCubit>()),
        BlocProvider<AuthCubit>.value(value: sl<AuthCubit>()),
        BlocProvider<MenuCubit>(create: (_) => sl<MenuCubit>()),
        BlocProvider<CartCubit>.value(value: sl<CartCubit>()),
        BlocProvider<OrderCubit>(create: (_) => sl<OrderCubit>()),
        BlocProvider<OrderTrackingCubit>(create: (_) => sl<OrderTrackingCubit>()),
        BlocProvider<DriverCubit>(create: (_) => sl<DriverCubit>()),
        BlocProvider<FeedbackCubit>(create: (_) => sl<FeedbackCubit>()),
        BlocProvider<NotificationsCubit>(create: (_) => sl<NotificationsCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'ريستو',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
