import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/resto_button.dart';
import '../../../../core/widgets/resto_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../data/models/order_model.dart';
import '../cubit/order_tracking_cubit.dart';
import '../cubit/order_tracking_state.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderTrackingCubit>().trackOrder(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      appBar: AppBar(
        title: Text(
          'تتبع الطلب',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<OrderTrackingCubit>().trackOrder(widget.orderId),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<OrderTrackingCubit, OrderTrackingState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryTerracotta),
                ),
              );
            }

            final order = state.order;
            if (order == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.errorRed),
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage ?? 'لم يتم العثور على الطلب',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Header Card
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
                            const SizedBox(height: 4),
                            Text(
                              order.orderType == OrderType.delivery
                                  ? 'توصيل لباب البيت'
                                  : 'استلام من الفرع',
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
                  const SizedBox(height: 20),

                  // Tracking Timeline Stepper Card
                  RestoCard(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مراحل تحضير وتوصيل الطلب',
                          style: GoogleFonts.cairo(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ...List.generate(state.steps.length, (index) {
                          final step = state.steps[index];
                          final isLast = index == state.steps.length - 1;
                          return _buildTimelineStep(step, isLast, isDark);
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Driver Card (if Delivery and assigned)
                  if (order.orderType == OrderType.delivery && order.driverName != null) ...[
                    RestoCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              color: AppColors.secondaryTerracotta,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(Icons.delivery_dining_rounded,
                                  color: Colors.white, size: 30),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.driverName!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'كابتن التوصيل المعين لطلبك',
                                  style: TextStyle(
                                    fontSize: 11,
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
                            leadingIcon: const Icon(Icons.phone_rounded, size: 16, color: Colors.white),
                            height: 38,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('جاري الاتصال بالكابتن ${order.driverPhone ?? ""}...'),
                                  backgroundColor: AppColors.successGreen,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],

                  // Delivery Location
                  RestoCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                color: AppColors.secondaryTerracotta, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              order.orderType == OrderType.delivery
                                  ? 'عنوان التوصيل'
                                  : 'فرع الاستلام',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: isDark ? Colors.white : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.orderType == OrderType.delivery
                              ? order.deliveryAddress
                              : order.pickupBranch,
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
                  const SizedBox(height: 20),

                  // Rating Action if Delivered
                  if (order.status == OrderStatus.delivered) ...[
                    RestoButton(
                      text: 'قيّم تجربتك مع هذا الطلب',
                      trailingIcon: const Icon(LucideIcons.star, size: 16, color: Colors.white),
                      onPressed: () => context.push('/customer/rate-order/${order.id}'),
                      width: double.infinity,
                    ),
                    const SizedBox(height: 14),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimelineStep(TrackingStep step, bool isLast, bool isDark) {
    Color indicatorColor;
    IconData icon;

    if (step.isCompleted) {
      indicatorColor = AppColors.successGreen;
      icon = Icons.check_rounded;
    } else if (step.isCurrent) {
      indicatorColor = AppColors.secondaryTerracotta;
      icon = Icons.radio_button_checked_rounded;
    } else {
      indicatorColor = isDark ? AppColors.outlineDark : AppColors.outlineLight;
      icon = Icons.circle_outlined;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stepper Line & Dot
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: indicatorColor.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: indicatorColor, width: 2),
              ),
              child: Center(
                child: Icon(icon, size: 16, color: indicatorColor),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 38,
                color: step.isCompleted
                    ? AppColors.successGreen
                    : (isDark ? AppColors.outlineDark : AppColors.outlineLight),
              ),
          ],
        ),
        const SizedBox(width: 14),

        // Step Text
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    fontWeight: step.isCurrent ? FontWeight.bold : FontWeight.w600,
                    fontSize: 14,
                    color: step.isCurrent
                        ? AppColors.secondaryTerracotta
                        : (isDark ? Colors.white : AppColors.primary),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  step.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
