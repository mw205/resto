import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class RestoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double borderRadius;
  final bool hasBorder;

  const RestoCard({
    super.key,
    required this.child,
    this.padding = AppDimensions.cardPadding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.borderRadius = AppDimensions.radiusLg,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = backgroundColor ??
        (isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight);

    final borderColor = isDark ? AppColors.outlineDark : AppColors.outlineLight;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: hasBorder ? Border.all(color: borderColor, width: 1) : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
