import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/resto_button.dart';
import '../../../../core/widgets/resto_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../orders/data/models/order_model.dart';
import '../cubit/driver_cubit.dart';
import '../cubit/driver_state.dart';

class DriverOrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const DriverOrderDetailsScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      appBar: AppBar(
        title: Text(
          'تفاصيل طلب التوصيل',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
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
          final order = state.selectedOrder ??
              state.assignedOrders.where((o) => o.id == orderId).firstOrNull;

          if (order == null) {
            return const Center(child: Text('لم يتم العثور على بيانات الطلب'));
          }

          final isDelivered = order.status == OrderStatus.delivered;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Status Card
                RestoCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'طلب رقم ${order.orderNumber}',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.primary,
                            ),
                          ),
                          Text(
                            DateFormatter.formatDate(order.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.onSurfaceVariantDark
                                  : AppColors.onSurfaceVariantLight,
                            ),
                          ),
                        ],
                      ),
                      StatusChip(
                        label: order.status.arabicTitle,
                        statusType: order.status.chipType,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Customer Info Card with Call Action
                RestoCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'بيانات العميل',
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryTerracotta.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person, color: AppColors.secondaryTerracotta),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.customerName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14),
                                ),
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
                          ),
                          RestoButton(
                            text: 'اتصال',
                            leadingIcon:
                                const Icon(Icons.phone_rounded, size: 16, color: Colors.white),
                            height: 38,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('جاري الاتصال بالعميل ${order.customerPhone}...'),
                                  backgroundColor: AppColors.successGreen,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Delivery Address
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.surfaceContainerLowDark
                              : AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on_rounded,
                                color: AppColors.secondaryTerracotta, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                order.deliveryAddress,
                                style: const TextStyle(fontSize: 13, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (order.customerNotes != null &&
                          order.customerNotes!.trim().isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          'ملاحظات العميل: ${order.customerNotes}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryTerracotta,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Items list
                RestoCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'أصناف الطلب (${order.items.length})',
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...order.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Text(
                                '${item.quantity}x ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondaryTerracotta,
                                ),
                              ),
                              Expanded(
                                child: Text(item.product.name,
                                    style: const TextStyle(fontSize: 13)),
                              ),
                              Text(
                                CurrencyFormatter.format(item.totalPrice),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        );
                      }),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'المبلغ المطلوب تحصيله كاش:',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.primary,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(order.total),
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryTerracotta,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Status Actions
                if (!isDelivered) ...[
                  if (order.status == OrderStatus.received ||
                      order.status == OrderStatus.preparing) ...[
                    RestoButton(
                      text: 'استلام الطلب وبدء التوصيل (في الطريق) 🛵',
                      onPressed: () {
                        context
                            .read<DriverCubit>()
                            .updateStatus(order.id, OrderStatus.onTheWay);
                      },
                      width: double.infinity,
                    ),
                  ] else if (order.status == OrderStatus.onTheWay) ...[
                    RestoButton(
                      text: 'تأكيد تسليم الطلب وتحصيل الكاش ✅',
                      variant: RestoButtonVariant.primary,
                      onPressed: () {
                        context
                            .read<DriverCubit>()
                            .updateStatus(order.id, OrderStatus.delivered);
                      },
                      width: double.infinity,
                    ),
                  ],
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.successGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                      border: Border.all(color: AppColors.successGreen),
                    ),
                    child: const Center(
                      child: Text(
                        'تم تسليم هذا الطلب بنجاح ✅',
                        style: TextStyle(
                          color: AppColors.successGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
