import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/resto_button.dart';
import '../../../../core/widgets/resto_card.dart';
import '../../../../core/widgets/resto_text_field.dart';
import '../../../orders/data/models/order_model.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      appBar: AppBar(
        title: Text(
          'سلة الطلبات',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.errorRed),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('تفريغ السلة'),
                      content: const Text('هل أنت متأكد من حذف جميع الأصناف من السلة؟'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('إلغاء'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<CartCubit>().clearCart();
                            Navigator.pop(ctx);
                          },
                          child: const Text(
                            'تفريغ',
                            style: TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state.couponError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.couponError!),
                backgroundColor: AppColors.errorRed,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryTerracotta.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 52,
                        color: AppColors.secondaryTerracotta,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'سلتك فاضية لسه!',
                      style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'تصفح قائمة الطعام واطلب أشهى المأكولات والمشويات المصرية',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    RestoButton(
                      text: 'تصفح قائمة الطعام الآن',
                      onPressed: () => context.push('/customer/menu'),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Type Selector (Delivery vs Takeaway)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceContainerLowDark : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    border: Border.all(
                      color: isDark ? AppColors.outlineDark : AppColors.outlineLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTypeOption(
                          context,
                          title: 'توصيل للبيت',
                          icon: LucideIcons.bike,
                          isSelected: state.orderType == OrderType.delivery,
                          onTap: () => context.read<CartCubit>().setOrderType(OrderType.delivery),
                          isDark: isDark,
                        ),
                      ),
                      Expanded(
                        child: _buildTypeOption(
                          context,
                          title: 'استلام من الفرع',
                          icon: LucideIcons.store,
                          isSelected: state.orderType == OrderType.takeaway,
                          onTap: () => context.read<CartCubit>().setOrderType(OrderType.takeaway),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Cart Items List
                Text(
                  'الأصناف المختارة (${state.totalItemsCount})',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),

                ...state.items.map((item) {
                  return RestoCard(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                          child: CachedNetworkImage(
                            imageUrl: item.product.imageUrl,
                            width: 75,
                            height: 75,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              width: 75,
                              height: 75,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.fastfood),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (item.specialInstructions.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryTerracotta.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                                  ),
                                  child: Text(
                                    'ملاحظة: ${item.specialInstructions}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.secondaryTerracotta,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    CurrencyFormatter.format(item.totalPrice),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondaryTerracotta,
                                      fontSize: 14,
                                    ),
                                  ),
                                  // Quantity +/-
                                  Container(
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.surfaceContainerHighDark
                                          : AppColors.surfaceContainerHigh,
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                                    ),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () => context
                                              .read<CartCubit>()
                                              .updateQuantity(item, item.quantity - 1),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Icon(Icons.remove, size: 16),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: Text(
                                            '${item.quantity}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 13),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => context
                                              .read<CartCubit>()
                                              .updateQuantity(item, item.quantity + 1),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Icon(Icons.add, size: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Coupon Code Section
                RestoCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.discount_outlined, color: AppColors.secondaryTerracotta, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'كوبون الخصم (جرب: RESTO20)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (state.appliedCoupon == null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: RestoTextField(
                                controller: _couponController,
                                hint: 'ادخل كود الكوبون...',
                              ),
                            ),
                            const SizedBox(width: 10),
                            RestoButton(
                              text: 'تطبيق',
                              height: 48,
                              onPressed: () {
                                context.read<CartCubit>().applyCoupon(_couponController.text);
                              },
                            ),
                          ],
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.successGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                            border: Border.all(color: AppColors.successGreen.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'تم تطبيق كوبون: ${state.appliedCoupon!.code}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.successGreen,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'وفرت ${CurrencyFormatter.format(state.discountAmount)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_rounded, color: AppColors.errorRed, size: 20),
                                onPressed: () {
                                  _couponController.clear();
                                  context.read<CartCubit>().removeCoupon();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Order Price Breakdown Summary
                RestoCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ملخص الفاتورة',
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildPriceRow('المجموع الفرعي', CurrencyFormatter.format(state.subtotal), isDark),
                      const SizedBox(height: 8),
                      _buildPriceRow(
                        'خدمة التوصيل',
                        state.orderType == OrderType.delivery
                            ? CurrencyFormatter.format(state.deliveryFee)
                            : 'مجاناً (استلام من الفرع)',
                        isDark,
                      ),
                      if (state.discountAmount > 0) ...[
                        const SizedBox(height: 8),
                        _buildPriceRow(
                          'الخصم',
                          '- ${CurrencyFormatter.format(state.discountAmount)}',
                          isDark,
                          isDiscount: true,
                        ),
                      ],
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'الإجمالي النهائي',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.primary,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(state.total),
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

                // Checkout Button
                RestoButton(
                  text: 'متابعة الدفع وتأكيد الطلب',
                  onPressed: () => context.push('/customer/checkout'),
                  width: double.infinity,
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeOption(
    BuildContext context, {
    required String title,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryTerracotta : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 6),
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, bool isDark, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDiscount
                ? AppColors.successGreen
                : (isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight),
          ),
        ),
      ],
    );
  }
}
