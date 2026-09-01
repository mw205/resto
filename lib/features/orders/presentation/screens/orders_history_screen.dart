import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/resto_button.dart';
import '../../../../core/widgets/resto_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../data/models/order_model.dart';
import '../cubit/order_cubit.dart';
import '../cubit/order_state.dart';

class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        appBar: AppBar(
          title: Text(
            'سجل طلباتي',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            labelColor: AppColors.secondaryTerracotta,
            unselectedLabelColor:
                isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
            indicatorColor: AppColors.secondaryTerracotta,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: const [
              Tab(text: 'الطلبات الحالية 🛵'),
              Tab(text: 'الطلبات السابقة 📋'),
            ],
          ),
        ),
        body: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            if (state.status == OrderStateStatus.loading && state.orders.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryTerracotta),
                ),
              );
            }

            return TabBarView(
              children: [
                _buildOrdersList(context, state.activeOrders, true, isDark),
                _buildOrdersList(context, state.pastOrders, false, isDark),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrdersList(
      BuildContext context, List<OrderModel> orders, bool isActive, bool isDark) {
    if (orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? Icons.moped_outlined : Icons.receipt_long_outlined,
                size: 64,
                color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
              ),
              const SizedBox(height: 14),
              Text(
                isActive ? 'لا توجد طلبات جارية حالياً' : 'لا توجد طلبات سابقة حتى الآن',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'اطلب أشهى المأكولات المصرية واستمتع بأحلى الأوقات',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return RestoCard(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          onTap: () => context.push('/customer/order-details/${order.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'طلب رقم ${order.orderNumber}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  StatusChip(
                    label: order.status.arabicTitle,
                    statusType: order.status.chipType,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                DateFormatter.formatDate(order.createdAt),
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
                ),
              ),
              const Divider(height: 20),

              // Items Summary
              Text(
                order.items.map((i) => '${i.quantity}x ${i.product.name}').join(' ، '),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Price & Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الإجمالي',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.onSurfaceVariantDark
                              : AppColors.onSurfaceVariantLight,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(order.total),
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryTerracotta,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (isActive) ...[
                        RestoButton(
                          text: 'تتبع الطلب',
                          height: 38,
                          onPressed: () =>
                              context.push('/customer/order-tracking/${order.id}'),
                        ),
                      ] else ...[
                        RestoButton(
                          text: 'إعادة الطلب 🔁',
                          variant: RestoButtonVariant.secondary,
                          height: 38,
                          onPressed: () {
                            for (var item in order.items) {
                              context.read<CartCubit>().addToCart(
                                    item.product,
                                    quantity: item.quantity,
                                    specialInstructions: item.specialInstructions,
                                  );
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تمت إضافة أصناف الطلب إلى السلة 🎉'),
                                backgroundColor: AppColors.successGreen,
                              ),
                            );
                            context.push('/customer/cart');
                          },
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
