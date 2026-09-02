import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/resto_card.dart';
import '../../../../core/widgets/resto_shimmer.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';
import '../../../notifications/presentation/cubit/notifications_state.dart';
import '../../data/models/product_model.dart';
import '../cubit/menu_cubit.dart';
import '../cubit/menu_state.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authUser = context.watch<AuthCubit>().state.user;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<MenuCubit>().loadMenuData();
            context.read<NotificationsCubit>().loadNotifications();
          },
          color: AppColors.secondaryTerracotta,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryTerracotta.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.secondaryTerracotta,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'التوصيل إلى',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
                              ),
                            ),
                            Text(
                              authUser?.savedAddresses.isNotEmpty == true
                                  ? authUser!.savedAddresses.first
                                  : 'القاهرة - مصر الجديدة',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      BlocBuilder<NotificationsCubit, NotificationsState>(
                        builder: (context, notifState) {
                          return IconButton(
                            onPressed: () => context.push('/notifications'),
                            icon: Badge(
                              isLabelVisible: notifState.unreadCount > 0,
                              label: Text('${notifState.unreadCount}'),
                              backgroundColor: AppColors.secondaryTerracotta,
                              child: Icon(
                                Icons.notifications_none_rounded,
                                color: isDark ? Colors.white : AppColors.primary,
                                size: 26,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Greeting & Tagline
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'مساء الخير يا ${authUser?.name.split(' ').first ?? 'فندم'}',
                            style: GoogleFonts.cairo(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(LucideIcons.hand, size: 24, color: Colors.amber),
                        ],
                      ),
                      Text(
                        'جاهز لتذوق أشهى الأطباق والمشويات المصرية؟',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Search Bar Trigger
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () => context.push('/customer/menu'),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceContainerLowDark : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        border: Border.all(
                          color: isDark ? AppColors.outlineDark : AppColors.outlineLight,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, color: AppColors.secondaryTerracotta, size: 22),
                          const SizedBox(width: 10),
                          Text(
                            'ابحث عن كشري، ملوخية، كباب، حواوشي...',
                            style: TextStyle(
                              color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),

                // Hero Promo Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                      image: const DecorationImage(
                        image: CachedNetworkImageProvider(AppAssets.bannerOfferImg),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.black.withValues(alpha: 0.85),
                            Colors.black.withValues(alpha: 0.4),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryTerracotta,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                            ),
                            child: const Text(
                              'كود الخصم: RESTO20',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'خصم 20% على كل المشويات',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'كباب وكفتة وشيش طاووق على الفحم الحجري',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Categories Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'أقسام الأكلات',
                        style: GoogleFonts.cairo(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.primary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/customer/menu'),
                        child: const Text(
                          'عرض المنيو',
                          style: TextStyle(
                            color: AppColors.secondaryTerracotta,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Horizontal Categories List
                BlocBuilder<MenuCubit, MenuState>(
                  builder: (context, state) {
                    if (state.status == MenuStatus.loading && state.categories.isEmpty) {
                      return SizedBox(
                        height: 90,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: 4,
                          separatorBuilder: (_, __) => const SizedBox(width: 14),
                          itemBuilder: (_, __) => const RestoShimmer(
                            width: 75,
                            height: 90,
                            borderRadius: AppDimensions.radiusLg,
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 96,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: state.categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final cat = state.categories[index];
                          return InkWell(
                            onTap: () {
                              context.read<MenuCubit>().selectCategory(cat.id);
                              context.push('/customer/menu');
                            },
                            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.surfaceContainerHighDark
                                        : AppColors.surfaceContainerHigh,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark ? AppColors.outlineDark : AppColors.outlineLight,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      _getCategoryIcon(cat.icon),
                                      size: 26,
                                      color: AppColors.secondaryTerracotta,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  cat.name,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Featured / Bestsellers Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'الأكثر طلباً والأشهر',
                            style: GoogleFonts.cairo(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(LucideIcons.flame, color: Colors.orange, size: 20),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                BlocBuilder<MenuCubit, MenuState>(
                  builder: (context, state) {
                    if (state.status == MenuStatus.loading && state.products.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: const [
                            FoodCardSkeleton(),
                            FoodCardSkeleton(),
                          ],
                        ),
                      );
                    }

                    final featured = state.featuredProducts.isNotEmpty
                        ? state.featuredProducts
                        : state.products.take(4).toList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: featured.map((product) {
                          return _buildFoodCard(context, product, isDark);
                        }).toList(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodCard(BuildContext context, ProductModel product, bool isDark) {
    return RestoCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      onTap: () => context.push('/customer/product/${product.id}'),
      child: Row(
        children: [
          // Food Image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              placeholder: (_, __) => const RestoShimmer(width: 90, height: 90),
              errorWidget: (_, __, ___) => Container(
                width: 90,
                height: 90,
                color: Colors.grey.shade300,
                child: const Icon(Icons.fastfood_rounded),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Details
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
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(LucideIcons.star, color: Colors.amber, size: 16),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryTerracotta,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.plus, color: Colors.white, size: 16),
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

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'beef': return LucideIcons.beef;
      case 'soup': return LucideIcons.soup;
      case 'utensils': return LucideIcons.utensils;
      case 'sandwich': return LucideIcons.sandwich;
      case 'dessert': return LucideIcons.cakeSlice;
      case 'cup-soda': return LucideIcons.cupSoda;
      default: return LucideIcons.utensils;
    }
  }
}
