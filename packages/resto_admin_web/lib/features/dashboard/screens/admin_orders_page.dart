import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:resto_core/resto_core.dart';
import '../cubit/admin_dashboard_cubit.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, state) {
        final orders = state.filteredOrders;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Header & Filter Tabs
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
                        'إدارة الطلبات (Orders Management)',
                        style: GoogleFonts.cairo(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryCharcoal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'متابعة الحالات وتحديث مراحل تحضير الطعام وتسليمه للكباتن',
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: AppColors.onSurfaceVariantLight,
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFilterChip(context, 'الكل', 'all', state.orderFilter),
                      _buildFilterChip(context, 'جديد', 'new', state.orderFilter),
                      _buildFilterChip(context, 'بالتحضير', 'preparing', state.orderFilter),
                      _buildFilterChip(context, 'في الطريق', 'delivering', state.orderFilter),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Orders Data Table Container
              Container(
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
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLg)),
                        border: Border(bottom: BorderSide(color: AppColors.outlineLight)),
                      ),
                      child: Row(
                        children: [
                          _tableColHeader('رقم الطلب', flex: 2),
                          _tableColHeader('العميل والهاتف', flex: 3),
                          _tableColHeader('الأصناف', flex: 3),
                          _tableColHeader('الإجمالي', flex: 2),
                          _tableColHeader('الحالة الحالية', flex: 2),
                          _tableColHeader('الإجراء السريع', flex: 3),
                        ],
                      ),
                    ),

                    // Table Rows
                    if (orders.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(48),
                        child: Center(
                          child: Text(
                            'لا توجد طلبات تطابق الفلتر المحدد',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: AppColors.onSurfaceVariantLight,
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: orders.length,
                        separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.outlineLight),
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            child: Row(
                              children: [
                                // Order ID
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '#${order.id.substring(order.id.length - 5)}',
                                    style: GoogleFonts.firaCode(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryCharcoal,
                                    ),
                                  ),
                                ),

                                // Customer & Phone
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.customerName,
                                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      Text(
                                        order.customerPhone,
                                        style: GoogleFonts.firaCode(
                                          fontSize: 12,
                                          color: AppColors.onSurfaceVariantLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Items Summary
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    order.items.map((i) => '${i.quantity}x ${i.product.name}').join('، '),
                                    style: GoogleFonts.cairo(fontSize: 12),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                // Total Amount
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    CurrencyFormatter.format(order.total),
                                    style: GoogleFonts.cairo(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondaryTerracotta,
                                    ),
                                  ),
                                ),

                                // Status
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: StatusChip(label: order.status.arabicTitle, statusType: order.status.chipType),
                                  ),
                                ),

                                // Action Buttons
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      if (order.status == OrderStatus.received)
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.secondaryTerracotta,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            textStyle: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            context.read<AdminDashboardCubit>().updateOrderStatus(
                                                  order.id,
                                                  OrderStatus.preparing,
                                                );
                                          },
                                          child: const Text('إرسال للمطبخ'),
                                        )
                                      else if (order.status == OrderStatus.preparing)
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primaryCharcoal,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            textStyle: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            context.read<AdminDashboardCubit>().updateOrderStatus(
                                                  order.id,
                                                  OrderStatus.onTheWay,
                                                );
                                          },
                                          child: const Text('تسليم للكابتن'),
                                        )
                                      else if (order.status == OrderStatus.onTheWay)
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.successGreen,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            textStyle: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            context.read<AdminDashboardCubit>().updateOrderStatus(
                                                  order.id,
                                                  OrderStatus.delivered,
                                                );
                                          },
                                          child: const Text('تأكيد التسليم'),
                                        )
                                      else
                                        Text(
                                          'مكتمل بنجاح',
                                          style: GoogleFonts.cairo(
                                            fontSize: 12,
                                            color: AppColors.successGreen,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, String filterKey, String currentFilter) {
    final isSelected = currentFilter == filterKey;
    return InkWell(
      onTap: () {
        context.read<AdminDashboardCubit>().setOrderFilter(filterKey);
      },
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryTerracotta : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: isSelected ? AppColors.secondaryTerracotta : AppColors.outlineLight,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.primaryCharcoal,
          ),
        ),
      ),
    );
  }

  Widget _tableColHeader(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurfaceVariantLight,
        ),
      ),
    );
  }
}
