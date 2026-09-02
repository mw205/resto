import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';

class CustomerMainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const CustomerMainScreen({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          final count = cartState.totalItemsCount;

          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onTap,
              backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
              indicatorColor: AppColors.secondaryTerracotta.withValues(alpha: 0.15),
              elevation: 0,
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded, color: AppColors.secondaryTerracotta),
                  label: 'الرئيسية',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.restaurant_menu_outlined),
                  selectedIcon: Icon(Icons.restaurant_menu_rounded, color: AppColors.secondaryTerracotta),
                  label: 'المنيو',
                ),
                NavigationDestination(
                  icon: Badge(
                    isLabelVisible: count > 0,
                    label: Text(
                      '$count',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: AppColors.secondaryTerracotta,
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                  selectedIcon: Badge(
                    isLabelVisible: count > 0,
                    label: Text(
                      '$count',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: AppColors.secondaryTerracotta,
                    child: const Icon(Icons.shopping_bag_rounded, color: AppColors.secondaryTerracotta),
                  ),
                  label: 'السلة',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long_rounded, color: AppColors.secondaryTerracotta),
                  label: 'طلباتي',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person_rounded, color: AppColors.secondaryTerracotta),
                  label: 'حسابي',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
