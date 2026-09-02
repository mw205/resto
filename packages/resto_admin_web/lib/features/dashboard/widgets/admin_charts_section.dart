import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resto_core/resto_core.dart';

class AdminChartsSection extends StatelessWidget {
  final double todayRevenue;
  final int totalOrders;

  const AdminChartsSection({
    super.key,
    required this.todayRevenue,
    required this.totalOrders,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 960;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: _buildHourlySalesCard(),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 4,
                child: _buildCategoryBreakdownCard(),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              _buildHourlySalesCard(),
              const SizedBox(height: 20),
              _buildCategoryBreakdownCard(),
            ],
          );
        }
      },
    );
  }

  Widget _buildHourlySalesCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.outlineLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(RestoIcons.trendingUp, color: AppColors.secondaryTerracotta, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'منحنى المبيعات والطلبات الحية (Hourly Volume)',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryCharcoal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'توزيع الطلبات على مدار ساعات عمل المطبخ اليوم',
                    style: GoogleFonts.cairo(fontSize: 12, color: AppColors.onSurfaceVariantLight),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondaryTerracotta.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.circle, color: AppColors.secondaryTerracotta, size: 8),
                    const SizedBox(width: 6),
                    Text(
                      'ذروة الطلبات: 8:00 مساءً',
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryTerracotta,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Custom Painted Spline Chart
          SizedBox(
            height: 200,
            width: double.infinity,
            child: CustomPaint(
              painter: _HourlySplineChartPainter(),
            ),
          ),
          const SizedBox(height: 16),

          // Chart Summary Highlights
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _chartMetricItem('متوسط قيمة الطلب', '285 ج.م', AppColors.primaryCharcoal),
              _chartMetricItem('معدل الطلب/ساعة', '14 طلب', AppColors.secondaryTerracotta),
              _chartMetricItem('أسرع تحضير', '16 دقيقة', AppColors.successGreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chartMetricItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(fontSize: 11, color: AppColors.onSurfaceVariantLight),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildCategoryBreakdownCard() {
    final categories = [
      {'name': 'مشويات وفحم (كباب وكفتة)', 'pct': 0.44, 'color': AppColors.secondaryTerracotta, 'revenue': '6,820 ج.م'},
      {'name': 'كشري وطواجن فخار', 'pct': 0.28, 'color': AppColors.primaryCharcoal, 'revenue': '4,340 ج.م'},
      {'name': 'أطباق رئيسية ومحاشي', 'pct': 0.18, 'color': AppColors.successGreen, 'revenue': '2,790 ج.م'},
      {'name': 'سندوتشات وحواوشي', 'pct': 0.10, 'color': Colors.amber.shade800, 'revenue': '1,550 ج.م'},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.outlineLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.pie_chart_outline_rounded, color: AppColors.primaryCharcoal, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'توزيع مبيعات الأصناف (Category Share)',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryCharcoal,
                    ),
                  ),
                ],
              ),
              Text(
                'اليوم',
                style: GoogleFonts.cairo(fontSize: 12, color: AppColors.onSurfaceVariantLight),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Doughnut Chart & Center Metric
          SizedBox(
            height: 150,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Center(
                    child: SizedBox(
                      width: 130,
                      height: 130,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(130, 130),
                            painter: _DoughnutChartPainter(
                              slices: categories.map((c) => (c['pct'] as num).toDouble()).toList(),
                              colors: categories.map((c) => c['color'] as Color).toList(),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'الأكثر طلباً',
                                style: GoogleFonts.cairo(fontSize: 10, color: AppColors.onSurfaceVariantLight),
                              ),
                              Text(
                                'المشويات',
                                style: GoogleFonts.cairo(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondaryTerracotta,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إجمالي المبيعات',
                        style: GoogleFonts.cairo(fontSize: 11, color: AppColors.onSurfaceVariantLight),
                      ),
                      Text(
                        CurrencyFormatter.format(todayRevenue),
                        style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryCharcoal),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '100% إنتاج طازج يومياً',
                        style: GoogleFonts.cairo(fontSize: 11, color: AppColors.successGreen, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Category Progress Bars List
          Column(
            children: categories.map((cat) {
              final pct = cat['pct'] as double;
              final color = cat['color'] as Color;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Text(cat['name'] as String, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Text(
                          '${(pct * 100).toInt()}% • ${cat['revenue']}',
                          style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryCharcoal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        backgroundColor: AppColors.surfaceLight,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Smooth Area Spline Chart
class _HourlySplineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final values = [12.0, 18.0, 25.0, 42.0, 58.0, 85.0, 100.0, 78.0, 45.0];
    final hours = ['12 ظ', '2 م', '4 م', '6 م', '8 م', '9 م', '10 م', '11 م', '12 ص'];

    final width = size.width;
    final height = size.height - 30; // leave space for text
    final dx = width / (values.length - 1);

    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = AppColors.outlineLight.withValues(alpha: 0.6)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= 3; i++) {
      final y = height * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }

    // Build Path
    final path = Path();
    final fillPath = Path();

    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = i * dx;
      final y = height - (values[i] / 100.0 * height * 0.85);
      points.add(Offset(x, y));
    }

    path.moveTo(points[0].dx, points[0].dy);
    fillPath.moveTo(points[0].dx, height);
    fillPath.lineTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      path.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
      fillPath.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    fillPath.lineTo(points.last.dx, height);
    fillPath.close();

    // Fill Gradient
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.secondaryTerracotta.withValues(alpha: 0.35),
          AppColors.secondaryTerracotta.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Stroke Line
    final strokePaint = Paint()
      ..color = AppColors.secondaryTerracotta
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, strokePaint);

    // Draw Points & Hour Labels
    final textPainter = TextPainter(textDirection: TextDirection.rtl);

    for (int i = 0; i < points.length; i++) {
      final pt = points[i];

      // Point circle
      final circlePaint = Paint()
        ..color = (i == 6) ? AppColors.secondaryTerracotta : Colors.white
        ..style = PaintingStyle.fill;
      final circleBorder = Paint()
        ..color = AppColors.secondaryTerracotta
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(pt, (i == 6) ? 6 : 4, circlePaint);
      canvas.drawCircle(pt, (i == 6) ? 6 : 4, circleBorder);

      // Hour text
      textPainter.text = TextSpan(
        text: hours[i],
        style: GoogleFonts.cairo(
          fontSize: 10,
          fontWeight: (i == 6) ? FontWeight.bold : FontWeight.normal,
          color: (i == 6) ? AppColors.secondaryTerracotta : AppColors.onSurfaceVariantLight,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(pt.dx - (textPainter.width / 2), height + 10));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Painter for Doughnut Slices
class _DoughnutChartPainter extends CustomPainter {
  final List<double> slices;
  final List<Color> colors;

  _DoughnutChartPainter({required this.slices, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 22.0;

    double startAngle = -math.pi / 2;

    for (int i = 0; i < slices.length; i++) {
      final sweepAngle = slices[i] * 2 * math.pi;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - (strokeWidth / 2)),
        startAngle,
        sweepAngle - 0.04, // tiny gap between slices
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
