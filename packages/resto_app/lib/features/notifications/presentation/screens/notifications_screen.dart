import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/resto_card.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      appBar: AppBar(
        title: Text(
          'الإشعارات',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded),
            tooltip: 'تحديد الكل كمقروء',
            onPressed: () {
              context.read<NotificationsCubit>().markAllAsRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تحديد جميع الإشعارات كمقروءة')),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: isDark
                        ? AppColors.onSurfaceVariantDark
                        : AppColors.onSurfaceVariantLight,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'لا توجد إشعارات جديدة',
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
            padding: const EdgeInsets.all(20),
            itemCount: state.notifications.length,
            itemBuilder: (context, index) {
              final notif = state.notifications[index];
              return RestoCard(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                backgroundColor: notif.isRead
                    ? (isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight)
                    : (isDark
                        ? AppColors.secondaryTerracotta.withValues(alpha: 0.12)
                        : AppColors.secondaryTerracotta.withValues(alpha: 0.06)),
                onTap: () {
                  if (notif.targetOrderId != null) {
                    context.push('/customer/order-tracking/${notif.targetOrderId}');
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: notif.type == 'promo'
                            ? Colors.amber.withValues(alpha: 0.2)
                            : AppColors.secondaryTerracotta.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        notif.type == 'promo'
                            ? Icons.local_offer_rounded
                            : Icons.delivery_dining_rounded,
                        color: notif.type == 'promo'
                            ? Colors.orange.shade800
                            : AppColors.secondaryTerracotta,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  notif.title,
                                  style: TextStyle(
                                    fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              if (!notif.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.secondaryTerracotta,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notif.body,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.onSurfaceVariantDark
                                  : AppColors.onSurfaceVariantLight,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormatter.formatTime(notif.createdAt),
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark
                                  ? AppColors.onSurfaceVariantDark
                                  : AppColors.onSurfaceVariantLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
