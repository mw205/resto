import 'package:flutter_test/flutter_test.dart';
import 'package:resto_core/utils/totp_authenticator.dart';

void main() {
  group('TotpAuthenticator Tests', () {
    test('generateCurrentCode returns 6-digit code', () {
      final code = TotpAuthenticator.generateCurrentCode();
      expect(code.length, equals(6));
      expect(int.tryParse(code), isNotNull);
    });

    test('verify returns true for currently generated code', () {
      final code = TotpAuthenticator.generateCurrentCode();
      final isValid = TotpAuthenticator.verify(enteredCode: code);
      expect(isValid, isTrue);
    });

    test('getOtpAuthUri returns valid otpauth string', () {
      final uri = TotpAuthenticator.getOtpAuthUri(
        accountName: 'admin@resto.eg',
        issuer: 'Resto',
      );
      expect(uri.startsWith('otpauth://totp/'), isTrue);
      expect(uri.contains('admin@resto.eg'), isTrue);
    });
  });
}
