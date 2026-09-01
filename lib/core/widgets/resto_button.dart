import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

enum RestoButtonVariant { primary, secondary, outline, ghost, destructive }

class RestoButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final RestoButtonVariant variant;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final double? width;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;

  const RestoButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = RestoButtonVariant.primary,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
    this.height = AppDimensions.buttonHeight,
    this.borderRadius = AppDimensions.radiusFull,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide? border;

    switch (variant) {
      case RestoButtonVariant.primary:
        backgroundColor = AppColors.secondaryTerracotta;
        foregroundColor = Colors.white;
        border = BorderSide.none;
        break;
      case RestoButtonVariant.secondary:
        backgroundColor = isDark
            ? AppColors.surfaceContainerHighDark
            : AppColors.surfaceContainerHigh;
        foregroundColor = isDark
            ? AppColors.onSurfaceDark
            : AppColors.onSurfaceLight;
        border = BorderSide.none;
        break;
      case RestoButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = isDark
            ? AppColors.onSurfaceDark
            : AppColors.onSurfaceLight;
        border = BorderSide(
          color: isDark ? AppColors.outlineDark : AppColors.outlineLight,
          width: 1.5,
        );
        break;
      case RestoButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.secondaryTerracotta;
        border = BorderSide.none;
        break;
      case RestoButtonVariant.destructive:
        backgroundColor = AppColors.errorRed;
        foregroundColor = Colors.white;
        border = BorderSide.none;
        break;
    }

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: onPressed == null
            ? backgroundColor.withValues(alpha: 0.5)
            : backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: border ?? BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          foregroundColor,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (leadingIcon != null) ...[
                          leadingIcon!,
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style:
                              textStyle ??
                              TextStyle(
                                color: foregroundColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (trailingIcon != null) ...[
                          const SizedBox(width: 8),
                          trailingIcon!,
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
