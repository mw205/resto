import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/theme/theme_cubit.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/resto_card.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = context.watch<AuthCubit>().state;
    final user = authState.user;
    final isDriver = authState.isDriver;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      appBar: AppBar(
        title: Text(
          'الملف الشخصي',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // User Card
              RestoCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryTerracotta,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          user?.name.isNotEmpty == true
                              ? user!.name.substring(0, 1)
                              : 'م',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'محمد فوزي',
                            style: GoogleFonts.cairo(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.phone ?? '01012345678',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.onSurfaceVariantDark
                                  : AppColors.onSurfaceVariantLight,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: isDriver
                                  ? AppColors.secondaryTerracotta.withOpacity(
                                      0.15,
                                    )
                                  : AppColors.successGreen.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusFull,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isDriver
                                      ? LucideIcons.bike
                                      : LucideIcons.star,
                                  size: 14,
                                  color: isDriver
                                      ? AppColors.secondaryTerracotta
                                      : AppColors.successGreen,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isDriver
                                      ? 'كابتن توصيل ديليفري'
                                      : 'عميل ريستو المميز',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isDriver
                                        ? AppColors.secondaryTerracotta
                                        : AppColors.successGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Settings & Controls
              RestoCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    // Dark Mode Switch
                    BlocBuilder<ThemeCubit, ThemeMode>(
                      builder: (context, mode) {
                        return SwitchListTile(
                          title: const Text(
                            'الوضع الليلي (Dark Mode)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          secondary: Icon(
                            isDark
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            color: AppColors.secondaryTerracotta,
                          ),
                          value: isDark,
                          activeThumbColor: AppColors.secondaryTerracotta,
                          onChanged: (val) =>
                              context.read<ThemeCubit>().toggleTheme(),
                        );
                      },
                    ),
                    const Divider(height: 1),

                    // Complaints & Suggestions
                    ListTile(
                      leading: const Icon(
                        Icons.support_agent_rounded,
                        color: AppColors.secondaryTerracotta,
                      ),
                      title: const Text(
                        'مركز الشكاوى والمقترحات',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                      ),
                      onTap: () => context.push('/customer/feedback'),
                    ),
                    const Divider(height: 1),

                    // Saved Addresses
                    ListTile(
                      leading: const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.secondaryTerracotta,
                      ),
                      title: const Text(
                        'العناوين المحفوظة',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        user?.savedAddresses.firstOrNull ??
                            'القاهرة - مصر الجديدة',
                        style: const TextStyle(fontSize: 11),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم حفظ عنوانك الافتراضي بنجاح'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // About Resto Card
              RestoCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'عن ريستو',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'تطبيق ريستو هو المنصة المصرية لتقديم أشهى المأكولات والمشويات والطواجن المصرية الأصيلة مع إمكانية التوصيل السريع وتتبع الطلب لحظة بلحظة.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: isDark
                            ? AppColors.onSurfaceVariantDark
                            : AppColors.onSurfaceVariantLight,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('الإصدار:', style: TextStyle(fontSize: 12)),
                        Text(
                          '1.0.0 (Culinary Heritage)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Logout Button
              RestoCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.errorRed,
                  ),
                  title: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      color: AppColors.errorRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('تسجيل الخروج'),
                        content: const Text(
                          'هل أنت متأكد من تسجيل الخروج من ريستو؟',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('إلغاء'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              context.read<AuthCubit>().logout();
                              context.go('/login');
                            },
                            child: const Text(
                              'خروج',
                              style: TextStyle(
                                color: AppColors.errorRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
