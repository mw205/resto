import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:resto_core/resto_core.dart';
import '../cubit/admin_dashboard_cubit.dart';
import '../widgets/admin_charts_section.dart';

class AdminOverviewPage extends StatelessWidget {
  const AdminOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryTerracotta),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              Wrap(
                spacing: 16,
                runSpacing: 12,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'لوحة مؤشرات العمليات (Overview)',
                        style: GoogleFonts.cairo(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryCharcoal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'متابعة فورية للمبيعات، طابور المطبخ، وأسطول كباتن التوصيل',
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: AppColors.onSurfaceVariantLight,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.successGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                      border: Border.all(color: AppColors.successGreen),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(RestoIcons.radio, color: AppColors.successGreen, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'المطبخ يستقبل الطلبات الآن',
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.successGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // KPI Metric Cards
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  final isMedium = constraints.maxWidth > 550;
                  return GridView.count(
                    crossAxisCount: isWide ? 4 : (isMedium ? 2 : 1),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isWide ? 1.7 : (isMedium ? 1.4 : 2.2),
                    children: [
                      _buildKpiCard(
                        title: 'مبيعات اليوم',
                        value: CurrencyFormatter.format(state.todayRevenue),
                        subtitle: '+14% مقارنة بالأمس',
                        icon: RestoIcons.banknote,
                        iconColor: AppColors.secondaryTerracotta,
                        trendUp: true,
                      ),
                      _buildKpiCard(
                        title: 'إجمالي الطلبات',
                        value: '${state.orders.length} طلب',
                        subtitle: 'معدل الإنجاز 98%',
                        icon: RestoIcons.receipt,
                        iconColor: AppColors.primaryCharcoal,
                        trendUp: true,
                      ),
                      _buildKpiCard(
                        title: 'قيد التجهيز بالمطبخ',
                        value: '${state.pendingOrdersCount} طلب',
                        subtitle: 'تتطلب متابعة الشيف',
                        icon: RestoIcons.chefHat,
                        iconColor: AppColors.warningOrange,
                        trendUp: false,
                      ),
                      _buildKpiCard(
                        title: 'كباتن في الطريق',
                        value: '${state.outForDeliveryCount} مندوب التوصيل',
                        subtitle: 'متوسط التوصيل 32 دقيقة',
                        icon: RestoIcons.bike,
                        iconColor: AppColors.successGreen,
                        trendUp: true,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),

              // Operational Analytics & Hourly Charts
              AdminChartsSection(
                todayRevenue: state.todayRevenue,
                totalOrders: state.orders.length,
              ),
              const SizedBox(height: 32),

              // Active Orders Queue & Popular Items Section
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;

                  final ordersCard = Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                      border: Border.all(color: AppColors.outlineLight),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(RestoIcons.clock, color: AppColors.secondaryTerracotta, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'أحدث طلبات المطبخ والتوصيل',
                                  style: GoogleFonts.cairo(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryCharcoal,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<AdminDashboardCubit>().selectNavIndex(1);
                              },
                              child: Text(
                                'عرض كافة الطلبات ←',
                                style: GoogleFonts.cairo(
                                  color: AppColors.secondaryTerracotta,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.orders.take(5).length,
                          separatorBuilder: (_, __) => const Divider(height: 24),
                          itemBuilder: (context, index) {
                            final order = state.orders[index];
                            return Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceLight,
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '#${order.id.substring(order.id.length - 3)}',
                                      style: GoogleFonts.firaCode(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: AppColors.primaryCharcoal,
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
                                        order.customerName,
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppColors.primaryCharcoal,
                                        ),
                                      ),
                                      Text(
                                        '${order.items.length} أصناف • ${DateFormatter.formatTime(order.createdAt)}',
                                        style: GoogleFonts.cairo(
                                          fontSize: 12,
                                          color: AppColors.onSurfaceVariantLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                StatusChip(label: order.status.arabicTitle, statusType: order.status.chipType),
                                const SizedBox(width: 16),
                                Text(
                                  CurrencyFormatter.format(order.total),
                                  style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.primaryCharcoal,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );

                  final popularCard = Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                      border: Border.all(color: AppColors.outlineLight),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(RestoIcons.flame, color: AppColors.secondaryTerracotta, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'الأكثر طلباً اليوم',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryCharcoal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.products.take(4).length,
                          separatorBuilder: (_, __) => const Divider(height: 20),
                          itemBuilder: (context, index) {
                            final product = state.products[index];
                            return Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    product.imageUrl,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 48,
                                      height: 48,
                                      color: AppColors.surfaceLight,
                                      child: const Icon(Icons.fastfood, size: 20),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        CurrencyFormatter.format(product.price),
                                        style: GoogleFonts.cairo(
                                          fontSize: 12,
                                          color: AppColors.secondaryTerracotta,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: product.isAvailable,
                                  activeThumbColor: AppColors.successGreen,
                                  onChanged: (_) {
                                    context
                                        .read<AdminDashboardCubit>()
                                        .toggleProductAvailability(product.id);
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: ordersCard),
                        const SizedBox(width: 20),
                        Expanded(flex: 4, child: popularCard),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        ordersCard,
                        const SizedBox(height: 20),
                        popularCard,
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool trendUp,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.outlineLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariantLight,
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryCharcoal,
            ),
          ),
          Row(
            children: [
              Icon(
                trendUp ? RestoIcons.trendingUp : RestoIcons.alertCircle,
                size: 14,
                color: trendUp ? AppColors.successGreen : AppColors.warningOrange,
              ),
              const SizedBox(width: 4),
              Text(
                subtitle,
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: trendUp ? AppColors.successGreen : AppColors.warningOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
