import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/resto_card.dart';
import '../../../../core/widgets/resto_shimmer.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../data/models/product_model.dart';
import '../cubit/menu_cubit.dart';
import '../cubit/menu_state.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      appBar: AppBar(
        title: Text(
          'قائمة الطعام',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => context.read<MenuCubit>().searchDishes(val),
                decoration: InputDecoration(
                  hintText: 'ابحث عن أكلتك المفضلة...',
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.secondaryTerracotta),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            context.read<MenuCubit>().searchDishes('');
                          },
                        )
                      : null,
                ),
              ),
            ),

            // Category Filter Pills
            BlocBuilder<MenuCubit, MenuState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      StatusChip(
                        label: 'الكل',
                        isSelected: state.selectedCategoryId == 'all',
                        onTap: () => context.read<MenuCubit>().selectCategory('all'),
                      ),
                      const SizedBox(width: 8),
                      ...state.categories.map((cat) {
                        final isSelected = state.selectedCategoryId == cat.id;
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: StatusChip(
                            label: '${cat.icon} ${cat.name}',
                            isSelected: isSelected,
                            onTap: () => context.read<MenuCubit>().selectCategory(cat.id),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),

            // Food Items List
            Expanded(
              child: BlocBuilder<MenuCubit, MenuState>(
                builder: (context, state) {
                  if (state.status == MenuStatus.loading && state.products.isEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: 4,
                      itemBuilder: (_, __) => const FoodCardSkeleton(),
                    );
                  }

                  if (state.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'لم يتم العثور على أطباق مطابقة للبحث',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return _buildProductCard(context, product, isDark);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product, bool isDark) {
    return RestoCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      onTap: () => context.push('/customer/product/${product.id}'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              width: 95,
              height: 95,
              fit: BoxFit.cover,
              placeholder: (_, __) => const RestoShimmer(width: 95, height: 95),
              errorWidget: (_, __, ___) => Container(
                width: 95,
                height: 95,
                color: Colors.grey.shade300,
                child: const Icon(Icons.fastfood_rounded),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                        const SizedBox(width: 2),
                        Text(
                          '${product.rating}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      size: 14,
                      color: AppColors.secondaryTerracotta.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${product.calories} سعرة',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.timer_outlined,
                      size: 14,
                      color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${product.preparationTimeMinutes} دقيقة',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CurrencyFormatter.format(product.price),
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryTerracotta,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.read<CartCubit>().addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('تمت إضافة ${product.name} للسلة'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: AppColors.successGreen,
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryTerracotta,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'إضافة',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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
  }
}
