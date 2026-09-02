import 'package:flutter_test/flutter_test.dart';
import 'package:resto_admin_web/features/auth/cubit/admin_auth_cubit.dart';
import 'package:resto_admin_web/features/auth/cubit/admin_auth_state.dart';

void main() {
  group('AdminAuthCubit', () {
    test('initial state has credentials step', () {
      final cubit = AdminAuthCubit();
      expect(cubit.state.step, equals(AdminAuthStep.credentials));
    });

    test('submitCredentials with non-admin email fails', () async {
      final cubit = AdminAuthCubit();
      await cubit.submitCredentials(email: 'user@resto.eg', password: '123');
      expect(cubit.state.errorMessage, isNotNull);
      expect(cubit.state.step, equals(AdminAuthStep.credentials));
    });

    test('submitCredentials with admin email advances to TOTP verification', () async {
      final cubit = AdminAuthCubit();
      await cubit.submitCredentials(email: 'admin@resto.eg', password: '123');
      expect(cubit.state.errorMessage, isNull);
      expect(cubit.state.step, equals(AdminAuthStep.totpVerification));
    });
  });
}
