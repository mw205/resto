import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/service_locator.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/cart/presentation/screens/checkout_screen.dart';
import '../../features/customer/presentation/screens/customer_main_screen.dart';
import '../../features/driver/presentation/screens/driver_order_details_screen.dart';
import '../../features/driver/presentation/screens/driver_orders_screen.dart';
import '../../features/feedback/presentation/screens/complaints_screen.dart';
import '../../features/feedback/presentation/screens/rate_order_screen.dart';
import '../../features/menu/presentation/screens/home_screen.dart';
import '../../features/menu/presentation/screens/menu_screen.dart';
import '../../features/menu/presentation/screens/product_details_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/orders/presentation/screens/order_confirmation_screen.dart';
import '../../features/orders/presentation/screens/order_details_screen.dart';
import '../../features/orders/presentation/screens/order_tracking_screen.dart';
import '../../features/orders/presentation/screens/orders_history_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  AppRouter._();

  static GoRouter createRouter(AuthCubit authCubit) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/splash',
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: (BuildContext context, GoRouterState state) {
        final authState = authCubit.state;
        final isAuth = authState.isAuthenticated;
        final isDriver = authState.user?.role == UserRole.driver;

        final isSplash = state.matchedLocation == '/splash';
        final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

        if (isSplash) return null;

        // If not authenticated and trying to access protected routes
        if (!isAuth && !isLoggingIn) {
          return '/login';
        }

        // If authenticated and visiting login
        if (isAuth && isLoggingIn) {
          return isDriver ? '/driver/orders' : '/customer/home';
        }

        // Role Guard: Customer attempting to access driver routes
        if (state.matchedLocation.startsWith('/driver') && !isDriver) {
          return '/customer/home';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),

        // Customer Main Shell Route with Bottom Navigation
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return CustomerMainScreen(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/customer/home',
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/customer/menu',
                  builder: (context, state) => const MenuScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/customer/cart',
                  builder: (context, state) => const CartScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/customer/orders',
                  builder: (context, state) => const OrdersHistoryScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/customer/profile',
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),

        // Standalone Customer Routes
        GoRoute(
          path: '/customer/product/:id',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final productId = state.pathParameters['id'] ?? '';
            return ProductDetailsScreen(productId: productId);
          },
        ),
        GoRoute(
          path: '/customer/checkout',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const CheckoutScreen(),
        ),
        GoRoute(
          path: '/customer/order-confirmation/:id',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final orderId = state.pathParameters['id'] ?? '';
            return OrderConfirmationScreen(orderId: orderId);
          },
        ),
        GoRoute(
          path: '/customer/order-tracking/:id',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final orderId = state.pathParameters['id'] ?? '';
            return OrderTrackingScreen(orderId: orderId);
          },
        ),
        GoRoute(
          path: '/customer/order-details/:id',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final orderId = state.pathParameters['id'] ?? '';
            return OrderDetailsScreen(orderId: orderId);
          },
        ),
        GoRoute(
          path: '/customer/rate-order/:id',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final orderId = state.pathParameters['id'] ?? '';
            return RateOrderScreen(orderId: orderId);
          },
        ),
        GoRoute(
          path: '/customer/feedback',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const ComplaintsScreen(),
        ),
        GoRoute(
          path: '/notifications',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const NotificationsScreen(),
        ),

        // Driver Portal Routes
        GoRoute(
          path: '/driver/orders',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const DriverOrdersScreen(),
        ),
        GoRoute(
          path: '/driver/order/:id',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final orderId = state.pathParameters['id'] ?? '';
            return DriverOrderDetailsScreen(orderId: orderId);
          },
        ),
      ],
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((dynamic _) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
