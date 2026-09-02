import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/resto_button.dart';
import '../../../../core/widgets/resto_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            password: _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.go('/customer/home');
        } else if (state.status == AuthStatus.error && state.errorMessage != null) {
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إنشاء حساب جديد',
                      style: GoogleFonts.cairo(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'انضم لريستو واستمتع بأشهى العروض والوجبات المصرية',
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Name
                    RestoTextField(
                      controller: _nameController,
                      label: 'الاسم بالكامل',
                      hint: 'محمد فوزي',
                      prefixIcon: const Icon(Icons.person_outline, size: 20),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'يرجى إدخال الاسم';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone
                    RestoTextField(
                      controller: _phoneController,
                      label: 'رقم الهاتف (للتوصيل)',
                      hint: '01012345678',
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                      validator: (val) {
                        if (val == null || val.trim().length < 11) {
                          return 'يرجى إدخال رقم هاتف صحيح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email
                    RestoTextField(
                      controller: _emailController,
                      label: 'البريد الإلكتروني',
                      hint: 'example@resto.eg',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      validator: (val) {
                        if (val == null || !val.contains('@')) {
                          return 'يرجى إدخال بريد إلكتروني صالح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    RestoTextField(
                      controller: _passwordController,
                      label: 'كلمة المرور',
                      hint: '••••••••',
                      obscureText: _obscurePassword,
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (val) {
                        if (val == null || val.length < 6) {
                          return 'كلمة المرور يجب ألا تقل عن 6 أحرف';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    RestoButton(
                      text: 'إنشاء الحساب',
                      onPressed: _submit,
                      isLoading: state.status == AuthStatus.loading,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 20),
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
