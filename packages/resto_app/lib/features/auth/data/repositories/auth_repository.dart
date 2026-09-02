import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/auth_interceptor.dart';
import '../../../../core/network/mock_resto_api.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });
  Future<void> logout();
  Future<UserModel?> getSavedUser();
  Future<void> switchRole(UserRole role);
}

class AuthRepositoryImpl implements AuthRepository {
  final MockRestoApi _api;
  final SharedPreferences _prefs;

  AuthRepositoryImpl(this._api, this._prefs);

  @override
  Future<UserModel> login({required String email, required String password}) async {
    final user = await _api.login(email: email, password: password);
    if (user.token != null) {
      await _prefs.setString(AuthInterceptor.tokenKey, user.token!);
    }
    return user;
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final user = await _api.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
    if (user.token != null) {
      await _prefs.setString(AuthInterceptor.tokenKey, user.token!);
    }
    return user;
  }

  @override
  Future<void> logout() async {
    await _api.logout();
    await _prefs.remove(AuthInterceptor.tokenKey);
  }

  @override
  Future<UserModel?> getSavedUser() async {
    return _api.getCurrentUser();
  }

  @override
  Future<void> switchRole(UserRole role) async {
    _api.switchToRole(role);
  }
}
