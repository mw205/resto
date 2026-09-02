import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

enum OrderStatusType {
  received,
  preparing,
  onTheWay,
  readyForPickup,
  delivered,
  cancelled,
}

class StatusChip extends StatelessWidget {
  final String label;
  final OrderStatusType? statusType;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const StatusChip({
    super.key,
    required this.label,
    this.statusType,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    if (statusType != null) {
      switch (statusType!) {
        case OrderStatusType.received:
          bg = const Color(0xFFE3F2FD);
          fg = const Color(0xFF1976D2);
          break;
        case OrderStatusType.preparing:
          bg = const Color(0xFFFFF3E0);
          fg = const Color(0xFFE65100);
          break;
        case OrderStatusType.onTheWay:
          bg = const Color(0xFFFBE9E7);
          fg = AppColors.secondaryDark;
          break;
        case OrderStatusType.readyForPickup:
          bg = const Color(0xFFE8F5E9);
          fg = const Color(0xFF2E7D32);
          break;
        case OrderStatusType.delivered:
          bg = const Color(0xFFE8F5E9);
          fg = AppColors.successGreen;
          break;
        case OrderStatusType.cancelled:
          bg = const Color(0xFFFFEBEE);
          fg = AppColors.errorRed;
          break;
      }
    } else if (isSelected) {
      bg = AppColors.secondaryTerracotta;
      fg = Colors.white;
    } else {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      bg = isDark ? AppColors.surfaceContainerHighDark : AppColors.surfaceContainer;
      fg = isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight;
    }

    if (backgroundColor != null) bg = backgroundColor!;
    if (textColor != null) fg = textColor!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: isSelected ? AppColors.secondaryTerracotta : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
