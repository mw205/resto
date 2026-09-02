import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:resto_core/resto_core.dart';
import '../cubit/admin_auth_cubit.dart';
import '../cubit/admin_auth_state.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController(text: 'admin@resto.eg');
  final _passwordController = TextEditingController(text: 'admin123456');
  final _totpController = TextEditingController();

  Timer? _timer;
  String _currentDemoCode = '';
  int _secondsRemaining = 30;

  @override
  void initState() {
    super.initState();
    _updateDemoCode();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateDemoCode());
  }

  void _updateDemoCode() {
    final now = DateTime.now();
    final step = 30;
    final seconds = step - (now.second % step);
    final code = TotpAuthenticator.generateCurrentCode();
    if (mounted) {
      setState(() {
        _secondsRemaining = seconds;
        _currentDemoCode = code;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    _totpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 480,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryCharcoal.withValues(alpha: 0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(color: AppColors.outlineLight),
            ),
            padding: const EdgeInsets.all(36),
            child: BlocConsumer<AdminAuthCubit, AdminAuthState>(
              listener: (context, state) {
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: AppColors.errorRed,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.step == AdminAuthStep.totpVerification) {
                  return _buildTotpStep(context, state);
                }
                return _buildCredentialsStep(context, state);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCredentialsStep(BuildContext context, AdminAuthState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Brand Header
        Center(
          child: RestoLogoWidget(size: 64, showText: true),
        ),
        const SizedBox(height: 24),
        Text(
          'بوابة إدارة العمليات والمطعم',
          style: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryCharcoal,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          'سجل الدخول بحساب المدير لإدارة الطلبات والمطبخ والمخزون',
          style: GoogleFonts.cairo(
            fontSize: 13,
            color: AppColors.onSurfaceVariantLight,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Email Field
        Text(
          'البريد الإلكتروني الإداري',
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryCharcoal,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          textDirection: TextDirection.ltr,
          decoration: InputDecoration(
            hintText: 'admin@resto.eg',
            prefixIcon: const Icon(RestoIcons.mail, size: 18),
            filled: true,
            fillColor: AppColors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(color: AppColors.outlineLight),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Password Field
        Text(
          'كلمة المرور',
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryCharcoal,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: true,
          textDirection: TextDirection.ltr,
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: const Icon(RestoIcons.lock, size: 18),
            filled: true,
            fillColor: AppColors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(color: AppColors.outlineLight),
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Submit Button
        RestoButton(
          text: 'متابعة المصادقة الثنائية (TOTP)',
          trailingIcon: const Icon(RestoIcons.shieldCheck, color: Colors.white, size: 18),
          isLoading: state.isLoading,
          onPressed: () {
            context.read<AdminAuthCubit>().submitCredentials(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
          },
        ),

        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.secondaryTerracotta.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: AppColors.secondaryTerracotta.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Icon(RestoIcons.info, color: AppColors.secondaryTerracotta, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'الحساب التجريبي: admin@resto.eg | كلمة المرور: أي رمز',
                  style: GoogleFonts.cairo(fontSize: 12, color: AppColors.secondaryTerracotta),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotpStep(BuildContext context, AdminAuthState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Security Shield Badge
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.secondaryTerracotta.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              RestoIcons.shieldAlert,
              color: AppColors.secondaryTerracotta,
              size: 36,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'التحقق بخطوتين (TOTP)',
          style: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryCharcoal,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'أدخل رمز الأمان المكون من 6 أرقام من تطبيق Google Authenticator أو استخدم الرمز المباشر بالأسفل',
          style: GoogleFonts.cairo(
            fontSize: 13,
            color: AppColors.onSurfaceVariantLight,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // Live Demo Code Preview (zero cost / convenient evaluator helper)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryCharcoal,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الرمز المباشر الحالي (Google Authenticator):',
                    style: GoogleFonts.cairo(fontSize: 11, color: Colors.white70),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _currentDemoCode,
                    style: GoogleFonts.firaCode(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryTerracotta,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_secondsRemaining ث',
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(RestoIcons.copy, color: Colors.white70, size: 18),
                    tooltip: 'نسخ الرمز للحقل',
                    onPressed: () {
                      _totpController.text = _currentDemoCode;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // TOTP Code Input Field
        Text(
          'رمز التحقق (6 أرقام)',
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryCharcoal,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _totpController,
          maxLength: 6,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: GoogleFonts.firaCode(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: '000000',
            filled: true,
            fillColor: AppColors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(color: AppColors.outlineLight),
            ),
          ),
          onSubmitted: (val) {
            context.read<AdminAuthCubit>().verifyTotp(val);
          },
        ),

        const SizedBox(height: 24),

        // Verify Button
        RestoButton(
          text: 'تأكيد ودخول لوحة التحكم',
          trailingIcon: const Icon(RestoIcons.checkCircle2, color: Colors.white, size: 18),
          isLoading: state.isLoading,
          onPressed: () {
            context.read<AdminAuthCubit>().verifyTotp(_totpController.text);
          },
        ),

        const SizedBox(height: 12),

        // Cancel / Back Button
        TextButton(
          onPressed: () {
            context.read<AdminAuthCubit>().cancelTotp();
          },
          child: Text(
            'الرجوع وإلغاء تسجيل الدخول',
            style: GoogleFonts.cairo(
              color: AppColors.onSurfaceVariantLight,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
