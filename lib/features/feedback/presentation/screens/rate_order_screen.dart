import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/resto_button.dart';
import '../../../../core/widgets/resto_text_field.dart';
import '../cubit/feedback_cubit.dart';
import '../cubit/feedback_state.dart';

class RateOrderScreen extends StatefulWidget {
  final String orderId;

  const RateOrderScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<RateOrderScreen> createState() => _RateOrderScreenState();
}

class _RateOrderScreenState extends State<RateOrderScreen> {
  double _rating = 5.0;
  final List<String> _availableTags = [
    'سرعة التوصيل',
    'طعم رائع ولذيذ',
    'تغليف ممتاز وفاخر',
    'الأكل ساخن وطازة',
    'كابتن التوصيل محترم ومحترف',
  ];
  final Set<String> _selectedTags = {'طعم رائع ولذيذ', 'الأكل ساخن وطازة'};
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<FeedbackCubit>().submitOrderRating(
          orderId: widget.orderId,
          rating: _rating,
          selectedTags: _selectedTags.toList(),
          comment: _commentController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<FeedbackCubit, FeedbackState>(
      listener: (context, state) {
        if (state.status == FeedbackStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage ?? 'شكراً لتقييمك!'),
              backgroundColor: AppColors.successGreen,
            ),
          );
          context.pop();
        } else if (state.status == FeedbackStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.errorRed,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          appBar: AppBar(
            title: Text(
              'تقييم الطلب',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  // Trophy / Star Icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.star_rounded, size: 44, color: Colors.amber),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'كيف كانت تجربتك مع ريستو؟',
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'رأيك الصادق يساعدنا في تقديم أفضل جودة للأكلات المصرية',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.onSurfaceVariantDark
                          : AppColors.onSurfaceVariantLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Star Rating Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starVal = index + 1.0;
                      return IconButton(
                        iconSize: 38,
                        icon: Icon(
                          _rating >= starVal ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: Colors.amber,
                        ),
                        onPressed: () => setState(() => _rating = starVal),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Praise Tags
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'ما الذي أعجبك في هذا الطلب؟',
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: _availableTags.map((tag) {
                      final isSelected = _selectedTags.contains(tag);
                      return ChoiceChip(
                        label: Text(tag),
                        selected: isSelected,
                        selectedColor: AppColors.secondaryTerracotta.withOpacity(0.15),
                        backgroundColor: isDark
                            ? AppColors.surfaceContainerLowDark
                            : AppColors.surfaceContainerLow,
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.secondaryTerracotta
                              : (isDark ? AppColors.outlineDark : AppColors.outlineLight),
                        ),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppColors.secondaryTerracotta
                              : (isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedTags.add(tag);
                            } else {
                              _selectedTags.remove(tag);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Comment Text Field
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'ملاحظات إضافية أو كلمة للشيف',
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  RestoTextField(
                    controller: _commentController,
                    hint: 'اكتب تقييمك بالتفصيل هنا...',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  RestoButton(
                    text: 'إرسال التقييم',
                    onPressed: _submit,
                    isLoading: state.status == FeedbackStatus.loading,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
