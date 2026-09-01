import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/resto_button.dart';
import '../../../../core/widgets/resto_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../orders/data/models/order_model.dart';
import '../cubit/driver_cubit.dart';
import '../cubit/driver_state.dart';

class DriverOrdersScreen extends StatelessWidget {
  const DriverOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = context.watch<AuthCubit>().state.user;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      appBar: AppBar(
        title: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'بوابة كابتن الديليفري',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(LucideIcons.bike, size: 18),
              ],
            ),
            Text(
              user?.name ?? 'كابتن هاني سعيد',
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? AppColors.onSurfaceVariantDark
                    : AppColors.onSurfaceVariantLight,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<DriverCubit>().loadAssignedOrders(),
          ),
        ],
      ),
      body: BlocConsumer<DriverCubit, DriverState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: AppColors.successGreen,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == DriverStatus.loading &&
              state.assignedOrders.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.secondaryTerracotta,
                ),
              ),
            );
          }

          if (state.assignedOrders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 64,
                      color: AppColors.successGreen,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'لا توجد طلبات معينة لك حالياً',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text('سيتم إشعارك فور تعيين طلب جديد للتوصيل'),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<DriverCubit>().loadAssignedOrders(),
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.assignedOrders.length,
              itemBuilder: (context, index) {
                final order = state.assignedOrders[index];
                final isDelivered = order.status == OrderStatus.delivered;

                return RestoCard(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  onTap: () {
                    context.read<DriverCubit>().selectOrder(order);
                    context.push('/driver/order/${order.id}');
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'طلب ${order.orderNumber}',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.primary,
                            ),
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
                          color: isDark
                              ? AppColors.onSurfaceVariantDark
                              : AppColors.onSurfaceVariantLight,
                        ),
                      ),
                      const Divider(height: 20),

                      // Customer Info
                      Row(
                        children: [
                          const Icon(
                            Icons.person_pin_rounded,
                            color: AppColors.secondaryTerracotta,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            order.customerName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            order.customerPhone,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.onSurfaceVariantDark
                                  : AppColors.onSurfaceVariantLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Address
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: AppColors.secondaryTerracotta,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              order.deliveryAddress,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.onSurfaceVariantDark
                                    : AppColors.onSurfaceVariantLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Items summary
                      Text(
                        'الأصناف: ${order.items.map((i) => "${i.quantity}x ${i.product.name}").join(" ، ")}',
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Divider(height: 20),

                      // Price & Action Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'التحصيل كاش',
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondaryTerracotta,
                                ),
                              ),
                            ],
                          ),
                          if (!isDelivered) ...[
                            if (order.status == OrderStatus.received ||
                                order.status == OrderStatus.preparing)
                              RestoButton(
                                text: 'بدء التوصيل (في الطريق)',
                                trailingIcon: const Icon(
                                  LucideIcons.bike,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                height: 40,
                                onPressed: () {
                                  context.read<DriverCubit>().updateStatus(
                                    order.id,
                                    OrderStatus.onTheWay,
                                  );
                                },
                              )
                            else if (order.status == OrderStatus.onTheWay)
                              RestoButton(
                                text: 'تم تسليم الطلب للعميل',
                                trailingIcon: const Icon(
                                  LucideIcons.checkCircle2,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                height: 40,
                                variant: RestoButtonVariant.primary,
                                onPressed: () {
                                  context.read<DriverCubit>().updateStatus(
                                    order.id,
                                    OrderStatus.delivered,
                                  );
                                },
                              ),
                          ] else ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.successGreen.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusFull,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'تم التسليم والتحصيل',
                                    style: TextStyle(
                                      color: AppColors.successGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    LucideIcons.checkCircle2,
                                    size: 14,
                                    color: AppColors.successGreen,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
