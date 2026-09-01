import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/resto_button.dart';
import '../../../../core/widgets/resto_text_field.dart';
import '../cubit/feedback_cubit.dart';
import '../cubit/feedback_state.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _orderNumberController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    _orderNumberController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<FeedbackCubit>().submitComplaint(
            orderId: _orderNumberController.text.trim().isNotEmpty
                ? _orderNumberController.text.trim()
                : null,
            subject: _subjectController.text.trim(),
            message: _messageController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<FeedbackCubit, FeedbackState>(
      listener: (context, state) {
        if (state.status == FeedbackStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage ?? 'تم إرسال رسالتك بنجاح'),
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
              'مركز الشكاوى والمقترحات',
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'نحن هنا لمساعدتك دائماً',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'إذا واجهتك أي مشكلة أو كان لديك اقتراح لتحسين خدمتنا، يسعدنا تواصلك مع إدارة ريستو مباشرة.',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.onSurfaceVariantDark
                            : AppColors.onSurfaceVariantLight,
                      ),
                    ),
                    const SizedBox(height: 24),

                    RestoTextField(
                      controller: _subjectController,
                      label: 'موضوع الرسالة',
                      hint: 'مثال: تأخر الطلب، اقتراح إضافة صنف جديد...',
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'يرجى إدخال موضوع الرسالة';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    RestoTextField(
                      controller: _orderNumberController,
                      label: 'رقم الطلب (اختياري)',
                      hint: 'مثال: EG-9481',
                    ),
                    const SizedBox(height: 16),

                    RestoTextField(
                      controller: _messageController,
                      label: 'تفاصيل الرسالة أو الشكوى',
                      hint: 'اكتب كل التفاصيل بوضوح...',
                      maxLines: 5,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'يرجى إدخال تفاصيل الرسالة';
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    RestoButton(
                      text: 'إرسال للإدارة',
                      onPressed: _submit,
                      isLoading: state.status == FeedbackStatus.loading,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
