import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class RestoShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final ShapeBorder? shapeBorder;

  const RestoShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppDimensions.radiusMd,
    this.shapeBorder,
  });

  const RestoShimmer.circular({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = size / 2,
        shapeBorder = const CircleBorder();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight,
      highlightColor: isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlightLight,
      child: Container(
        width: width,
        height: height,
        decoration: shapeBorder == null
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
              )
            : ShapeDecoration(
                color: Colors.white,
                shape: shapeBorder!,
              ),
      ),
    );
  }
}

class FoodCardSkeleton extends StatelessWidget {
  const FoodCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: const Row(
        children: [
          RestoShimmer(width: 90, height: 90, borderRadius: AppDimensions.radiusMd),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RestoShimmer(width: 140, height: 16),
                SizedBox(height: 8),
                RestoShimmer(width: double.infinity, height: 12),
                SizedBox(height: 6),
                RestoShimmer(width: 100, height: 12),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RestoShimmer(width: 70, height: 16),
                    RestoShimmer(width: 32, height: 32, borderRadius: AppDimensions.radiusFull),
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
