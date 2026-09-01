import 'package:flutter_test/flutter_test.dart';
import 'package:resto/core/network/mock_resto_api.dart';
import 'package:resto/features/auth/data/models/user_model.dart';
import 'package:resto/features/auth/data/repositories/auth_repository.dart';
import 'package:resto/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:resto/features/auth/presentation/cubit/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late MockRestoApi api;
  late SharedPreferences prefs;
  late AuthRepository repository;
  late AuthCubit authCubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    api = MockRestoApi();
    repository = AuthRepositoryImpl(api, prefs);
    authCubit = AuthCubit(repository);
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit Tests', () {
    test('initial checkAuthStatus authenticates with saved user if available', () async {
      await authCubit.checkAuthStatus();
      expect(authCubit.state.status, AuthStatus.authenticated);
      expect(authCubit.state.user?.role, UserRole.customer);
    });

    test('login with driver email sets role to driver', () async {
      await authCubit.login(email: 'driver@resto.eg', password: 'secretpassword');

      expect(authCubit.state.status, AuthStatus.authenticated);
      expect(authCubit.state.isDriver, true);
      expect(authCubit.state.user?.name, 'كابتن هاني سعيد');
    });

    test('switchRole to driver updates state', () async {
      await authCubit.switchRole(UserRole.driver);

      expect(authCubit.state.isDriver, true);
      expect(authCubit.state.user?.role, UserRole.driver);
    });

    test('logout sets unauthenticated state', () async {
      await authCubit.logout();

      expect(authCubit.state.status, AuthStatus.unauthenticated);
      expect(authCubit.state.user, null);
    });
  });
}
