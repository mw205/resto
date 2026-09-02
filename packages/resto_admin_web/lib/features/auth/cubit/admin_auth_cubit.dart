import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resto_core/resto_core.dart';
import 'admin_auth_state.dart';

class AdminAuthCubit extends Cubit<AdminAuthState> {
  final MockRestoApi _api = MockRestoApi();

  AdminAuthCubit() : super(const AdminAuthState());

  Future<void> submitCredentials({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    await Future.delayed(const Duration(milliseconds: 500));

    final trimmed = email.trim().toLowerCase();
    if (!trimmed.contains('admin')) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'هذا الحساب ليس لديه صلاحيات مدير النظام (يرجى استخدام admin@resto.eg)',
      ));
      return;
    }

    if (password.trim().isEmpty) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'يرجى إدخال كلمة المرور',
      ));
      return;
    }

    // Step 1 Passed -> Prompt for TOTP 2FA Verification
    emit(state.copyWith(
      isLoading: false,
      step: AdminAuthStep.totpVerification,
      pendingEmail: trimmed,
      errorMessage: null,
    ));
  }

  Future<void> verifyTotp(String code) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    await Future.delayed(const Duration(milliseconds: 400));

    final isValid = TotpAuthenticator.verify(
      enteredCode: code,
      secret: state.totpSecret,
    );

    if (isValid) {
      final user = await _api.login(email: state.pendingEmail, password: 'mock_password');
      emit(state.copyWith(
        isLoading: false,
        step: AdminAuthStep.authenticated,
        user: user,
        errorMessage: null,
      ));
    } else {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'رمز المصادقة الثنائية (TOTP) غير صحيح أو انتهت صلاحيته',
      ));
    }
  }

  void cancelTotp() {
    emit(state.copyWith(
      step: AdminAuthStep.credentials,
      errorMessage: null,
    ));
  }

  void logout() {
    _api.logout();
    emit(const AdminAuthState(step: AdminAuthStep.credentials));
  }
}
