import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../cubit/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        final authState = context.read<AuthCubit>().state;
        if (authState.isAuthenticated) {
          if (authState.isDriver) {
            context.go('/driver/orders');
          } else {
            context.go('/customer/home');
          }
        } else {
          context.go('/login');
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Icon / Emblem
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryTerracotta,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondaryTerracotta.withOpacity(0.35),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.restaurant_menu_rounded,
                      size: 56,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // App Title (Literata / Cairo serif)
                Text(
                  'ريستو',
                  style: GoogleFonts.cairo(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : AppColors.primary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),

                // Tagline
                Text(
                  'أشهى المأكولات والمشويات المصرية على أصولها',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Loading Indicator
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryTerracotta),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
