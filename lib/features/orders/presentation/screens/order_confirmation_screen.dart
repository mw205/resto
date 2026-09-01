import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/resto_button.dart';
import '../../../../core/widgets/resto_card.dart';
import '../cubit/order_cubit.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String orderId;

  const OrderConfirmationScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().fetchOrderDetails(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final order = context.watch<OrderCubit>().state.currentOrder;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go('/customer/home');
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Animated Check Icon Container
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 68,
                      color: AppColors.successGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  'تم استلام طلبك بنجاح! 🎉',
                  style: GoogleFonts.cairo(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'شكراً لطلبك من ريستو. المطبخ بدأ في تجهيز أكلتك المصرية بكل حب واهتمام',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                // Order Info Card
                if (order != null) ...[
                  RestoCard(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('رقم الطلب:', style: TextStyle(fontSize: 13)),
                            Text(
                              order.orderNumber,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('الوقت المتوقع:', style: TextStyle(fontSize: 13)),
                            const Text(
                              '30 - 45 دقيقة',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondaryTerracotta,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('المبلغ المطلوب:', style: TextStyle(fontSize: 13)),
                            Text(
                              CurrencyFormatter.format(order.total),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                const Spacer(),

                // Track Order Button
                RestoButton(
                  text: 'تتبع حالة الطلب لحظة بلحظة 🛵',
                  onPressed: () {
                    context.push('/customer/order-tracking/${widget.orderId}');
                  },
                  width: double.infinity,
                ),
                const SizedBox(height: 12),

                // Back to Home Button
                RestoButton(
                  text: 'العودة للصفحة الرئيسية',
                  variant: RestoButtonVariant.secondary,
                  onPressed: () => context.go('/customer/home'),
                  width: double.infinity,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
