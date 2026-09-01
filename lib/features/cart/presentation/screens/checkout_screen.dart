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
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../orders/presentation/cubit/order_cubit.dart';
import '../cubit/cart_cubit.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.user;
    final cart = context.read<CartCubit>().state;
    _addressController.text = cart.deliveryAddress.isNotEmpty
        ? cart.deliveryAddress
        : (user?.savedAddresses.isNotEmpty == true ? user!.savedAddresses.first : '');
    _phoneController.text = user?.phone ?? '01012345678';
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _placeOrder() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    final cart = context.read<CartCubit>().state;
    final orderCubit = context.read<OrderCubit>();

    final newOrder = await orderCubit.placeOrder(
      items: cart.items,
      orderType: cart.orderType,
      deliveryAddress: _addressController.text.trim(),
      pickupBranch: cart.pickupBranch,
      customerPhone: _phoneController.text.trim(),
      customerNotes: _notesController.text.trim(),
      discount: cart.discountAmount,
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (newOrder != null) {
        context.read<CartCubit>().clearCart();
        context.go('/customer/order-confirmation/${newOrder.id}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cart = context.watch<CartCubit>().state;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      appBar: AppBar(
        title: Text(
          'تأكيد الطلب والدفع',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery/Takeaway Info Card
                RestoCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            cart.orderType == OrderType.delivery
                                ? Icons.delivery_dining_rounded
                                : Icons.storefront_rounded,
                            color: AppColors.secondaryTerracotta,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            cart.orderType == OrderType.delivery
                                ? 'بيانات التوصيل للعنوان'
                                : 'بيانات استلام من الفرع',
                            style: GoogleFonts.cairo(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (cart.orderType == OrderType.delivery) ...[
                        RestoTextField(
                          controller: _addressController,
                          label: 'عنوان التوصيل بالتفصيل',
                          hint: 'المنطقة، اسم الشارع، رقم العمارة، رقم الشقة أو علامة مميزة',
                          maxLines: 2,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'يرجى إدخال عنوان التوصيل';
                            }
                            return null;
                          },
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.surfaceContainerLowDark
                                : AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.store, color: AppColors.secondaryTerracotta),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  cart.pickupBranch,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      RestoTextField(
                        controller: _phoneController,
                        label: 'رقم الهاتف للتواصل',
                        hint: '01012345678',
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          if (val == null || val.trim().length < 11) {
                            return 'يرجى إدخال رقم هاتف صحيح (11 رقم)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      RestoTextField(
                        controller: _notesController,
                        label: 'ملاحظات للكابتن أو الفرع',
                        hint: 'مثال: رن الجرس واسيب الطلب عند الباب...',
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Payment Method Card
                RestoCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'طريقة الدفع',
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryTerracotta.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                          border: Border.all(color: AppColors.secondaryTerracotta, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.payments_rounded,
                              color: AppColors.secondaryTerracotta,
                              size: 26,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'الدفع كاش عند الاستلام (نقداً)',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  Text(
                                    'الدفع لمندوب التوصيل أو الكاشير عند استلام الوجبة ساخنة',
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
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.secondaryTerracotta,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Order Final Summary
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
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('عدد الأصناف:'),
                          Text('${cart.totalItemsCount} أصناف',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('المجموع الفرعي:'),
                          Text(CurrencyFormatter.format(cart.subtotal)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('خدمة التوصيل:'),
                          Text(cart.orderType == OrderType.delivery
                              ? CurrencyFormatter.format(cart.deliveryFee)
                              : 'مجاناً'),
                        ],
                      ),
                      if (cart.discountAmount > 0) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('الخصم:', style: TextStyle(color: AppColors.successGreen)),
                            Text('- ${CurrencyFormatter.format(cart.discountAmount)}',
                                style: const TextStyle(
                                    color: AppColors.successGreen, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'المبلغ المطلوب دفعه:',
                            style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            CurrencyFormatter.format(cart.total),
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

                RestoButton(
                  text: 'تأكيد الطلب الآن',
                  trailingIcon: const Icon(LucideIcons.partyPopper, size: 16, color: Colors.white),
                  onPressed: _placeOrder,
                  isLoading: _isSubmitting,
                  width: double.infinity,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
