import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      final user = await _repository.getSavedUser();
      if (user != null) {
        emit(state.copyWith(status: AuthStatus.authenticated, user: user));
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      }
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      final user = await _repository.login(email: email, password: password);
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'بيانات الدخول غير صحيحة، يرجى المحاولة مرة أخرى',
      ));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      final user = await _repository.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'حدث خطأ أثناء إنشاء الحساب، يرجى التأكد من البيانات',
      ));
    }
  }

  Future<void> switchRole(UserRole role) async {
    emit(state.copyWith(status: AuthStatus.loading));
    await _repository.switchRole(role);
    final user = await _repository.getSavedUser();
    emit(state.copyWith(status: AuthStatus.authenticated, user: user));
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    await _repository.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
