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
import 'package:lucide_icons_flutter/lucide_icons.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().fetchOrderDetails(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      appBar: AppBar(
        title: Text(
          'تفاصيل الطلب',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          final order = state.currentOrder ??
              state.orders.where((o) => o.id == widget.orderId).firstOrNull;

          if (order == null) {
            return const Center(child: Text('لم يتم العثور على تفاصيل الطلب'));
          }

          final isDelivered = order.status == OrderStatus.delivered;
          final isActive = order.status != OrderStatus.delivered &&
              order.status != OrderStatus.cancelled;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Info Card
                RestoCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'طلب رقم ${order.orderNumber}',
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
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 14),
                          const SizedBox(width: 6),
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
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Items List Card
                RestoCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'محتويات الطلب',
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...order.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryTerracotta.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${item.quantity}x',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondaryTerracotta,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    if (item.specialInstructions.isNotEmpty) ...[
                                      Text(
                                        'ملاحظة: ${item.specialInstructions}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark
                                              ? AppColors.onSurfaceVariantDark
                                              : AppColors.onSurfaceVariantLight,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Text(
                                CurrencyFormatter.format(item.totalPrice),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Delivery Info Card
                RestoCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.orderType == OrderType.delivery
                            ? 'بيانات التوصيل'
                            : 'بيانات الاستلام من الفرع',
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        order.orderType == OrderType.delivery
                            ? order.deliveryAddress
                            : order.pickupBranch,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.onSurfaceVariantDark
                              : AppColors.onSurfaceVariantLight,
                        ),
                      ),
                      if (order.customerPhone.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          'رقم الهاتف: ${order.customerPhone}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Price Summary Card
                RestoCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ملخص الدفع',
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('المجموع الفرعي:'),
                          Text(CurrencyFormatter.format(order.subtotal)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('خدمة التوصيل:'),
                          Text(order.orderType == OrderType.delivery
                              ? CurrencyFormatter.format(order.deliveryFee)
                              : 'مجاناً'),
                        ],
                      ),
                      if (order.discount > 0) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('الخصم:',
                                style: TextStyle(color: AppColors.successGreen)),
                            Text('- ${CurrencyFormatter.format(order.discount)}',
                                style: const TextStyle(
                                    color: AppColors.successGreen,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'الإجمالي المدفوع (كاش):',
                            style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold),
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
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                if (isActive) ...[
                  RestoButton(
                    text: 'تتبع حالة الطلب لحظياً',
                    trailingIcon: const Icon(LucideIcons.bike, size: 16, color: Colors.white),
                    onPressed: () =>
                        context.push('/customer/order-tracking/${order.id}'),
                    width: double.infinity,
                  ),
                  const SizedBox(height: 12),
                ],

                if (isDelivered) ...[
                  RestoButton(
                    text: 'تقييم الوجبة والتوصيل',
                    trailingIcon: const Icon(LucideIcons.star, size: 16, color: Colors.white),
                    onPressed: () =>
                        context.push('/customer/rate-order/${order.id}'),
                    width: double.infinity,
                  ),
                  const SizedBox(height: 12),
                ],

                RestoButton(
                  text: 'إعادة هذا الطلب',
                  trailingIcon: const Icon(LucideIcons.refreshCcw, size: 16, color: AppColors.primary),
                  variant: RestoButtonVariant.secondary,
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
                        content: Text('تمت إضافة أصناف الطلب إلى السلة'),
                        backgroundColor: AppColors.successGreen,
                      ),
                    );
                    context.push('/customer/cart');
                  },
                  width: double.infinity,
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
