import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/resto_button.dart';
import '../../../../core/widgets/resto_text_field.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../data/models/product_model.dart';
import '../cubit/menu_cubit.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final products = context.watch<MenuCubit>().state.products;
    final product = products.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => const ProductModel(
        id: '',
        name: 'غير متوفر',
        description: '',
        price: 0,
        imageUrl: '',
        categoryId: '',
        categoryName: '',
      ),
    );

    if (product.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('لم يتم العثور على الصنف')),
      );
    }

    final totalPrice = product.price * _quantity;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      body: CustomScrollView(
        slivers: [
          // Hero Image AppBar
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: isDark ? Colors.black54 : Colors.white70,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: isDark ? Colors.white : AppColors.primary,
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.fastfood, size: 64),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: GoogleFonts.cairo(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.primary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              '${product.rating} (${product.reviewsCount})',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Metadata Badges (Calories, Prep time, Category)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceContainerHighDark : AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_fire_department_rounded,
                                size: 16, color: AppColors.secondaryTerracotta),
                            const SizedBox(width: 4),
                            Text(
                              '${product.calories} سعرة حرارية',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceContainerHighDark : AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer_outlined, size: 16, color: AppColors.secondaryDark),
                            const SizedBox(width: 4),
                            Text(
                              '${product.preparationTimeMinutes} دقيقة تحضير',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text(
                    'الوصف وطريقة التحضير',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Ingredients
                  if (product.ingredients.isNotEmpty) ...[
                    Text(
                      'المكونات الأساسية',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: product.ingredients.map((ing) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.surfaceContainerLowDark
                                : AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                            border: Border.all(
                              color: isDark ? AppColors.outlineDark : AppColors.outlineLight,
                            ),
                          ),
                          child: Text(
                            ing,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 22),
                  ],

                  // Special Notes (Customizations: e.g. بدون بصل، زيادة شطة...)
                  Text(
                    'ملاحظات خاصة للمطبخ',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RestoTextField(
                    controller: _notesController,
                    hint: 'مثال: بدون بصل، زيادة شطة، تقلية خارجية، صوص زيادة...',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 28),

                  // Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الكمية المطلوبة',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.primary,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.surfaceContainerHighDark
                              : AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () {
                                if (_quantity > 1) {
                                  setState(() => _quantity--);
                                }
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: RestoButton(
            text: 'إضافة للسلة • ${CurrencyFormatter.format(totalPrice)}',
            onPressed: () {
              context.read<CartCubit>().addToCart(
                    product,
                    quantity: _quantity,
                    specialInstructions: _notesController.text.trim(),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تمت إضافة $_quantity من ${product.name} للسلة 🎉'),
                  duration: const Duration(seconds: 1),
                  backgroundColor: AppColors.successGreen,
                ),
              );
              context.pop();
            },
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
