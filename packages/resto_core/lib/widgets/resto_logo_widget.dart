import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class RestoLogoWidget extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isDark;

  const RestoLogoWidget({
    super.key,
    this.size = 48,
    this.showText = true,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/resto_app_icon.jpg',
            package: 'resto_core',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.primaryCharcoal,
              alignment: Alignment.center,
              child: Icon(
                Icons.restaurant_menu,
                color: AppColors.secondaryTerracotta,
                size: size * 0.6,
              ),
            ),
          ),
        ),
        if (showText) ...[
          SizedBox(width: size * 0.25),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ريستو',
                style: GoogleFonts.cairo(
                  fontSize: size * 0.48,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.onSurfaceDark : AppColors.primaryCharcoal,
                  height: 1.1,
                ),
              ),
              Text(
                'RESTO GOURMET',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: size * 0.2,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppColors.secondaryTerracotta,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
