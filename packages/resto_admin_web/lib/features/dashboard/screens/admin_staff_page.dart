import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:resto_core/resto_core.dart';

class AdminStaffPage extends StatelessWidget {
  const AdminStaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    final staff = [
      {'name': 'كابتن هاني سعيد', 'phone': '01198765432', 'status': 'في طريق التوصيل', 'vehicle': 'موتوسيكل Honda', 'orders': 14, 'rating': '4.9'},
      {'name': 'كابتن أحمد سامي', 'phone': '01022334455', 'status': 'متاح للطلب القادم', 'vehicle': 'موتوسيكل Boxer', 'orders': 18, 'rating': '5.0'},
      {'name': 'كابتن محمود علي', 'phone': '01233445566', 'status': 'متاح للطلب القادم', 'vehicle': 'سكوتر كهربائي', 'orders': 9, 'rating': '4.8'},
      {'name': 'كابتن طارق يحيى', 'phone': '01511223344', 'status': 'استراحة غداء', 'vehicle': 'موتوسيكل Bajaj', 'orders': 12, 'rating': '4.7'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    'كباتن التوصيل والأسطول (Delivery Staff)',
                    style: GoogleFonts.cairo(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryCharcoal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'متابعة حركة كباتن التوصيل في شوارع القاهرة وحالات التسليم وسجل التقييمات',
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      color: AppColors.onSurfaceVariantLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(color: AppColors.outlineLight),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: staff.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.outlineLight),
              itemBuilder: (context, index) {
                final driver = staff[index];
                final isAvailable = driver['status'] == 'متاح للطلب القادم';

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primaryCharcoal,
                        child: const Icon(RestoIcons.bike, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driver['name'] as String,
                              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              '${driver['vehicle']} • ${driver['phone']}',
                              style: GoogleFonts.cairo(fontSize: 12, color: AppColors.onSurfaceVariantLight),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isAvailable
                                ? AppColors.successGreen.withValues(alpha: 0.1)
                                : AppColors.warningOrange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                          ),
                          child: Text(
                            driver['status'] as String,
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isAvailable ? AppColors.successGreen : AppColors.warningOrange,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(RestoIcons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${driver['rating']} (${driver['orders']} طلب اليوم)',
                              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
