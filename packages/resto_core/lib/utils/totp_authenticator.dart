import 'package:otp/otp.dart';

/// TOTP (Time-based One-Time Password) Authenticator implementing RFC 6238.
/// Compatible with Google Authenticator, Microsoft Authenticator, and Authy.
class TotpAuthenticator {
  /// Default shared secret for Resto Admin Operations in base32
  static const String defaultAdminSecret = 'JBSWY3DPEHPK3PXP';

  /// Generates the standard 6-digit TOTP code for the current time.
  static String generateCurrentCode({String secret = defaultAdminSecret, int interval = 30}) {
    return OTP.generateTOTPCodeString(
      secret,
      DateTime.now().millisecondsSinceEpoch,
      interval: interval,
      length: 6,
      algorithm: Algorithm.SHA1,
      isGoogle: true,
    );
  }

  /// Verifies a 6-digit TOTP code against the secret.
  /// Includes a 1-step window (+- 30 seconds) to account for client-server clock skew.
  static bool verify({
    required String enteredCode,
    String secret = defaultAdminSecret,
    int interval = 30,
  }) {
    final cleaned = enteredCode.replaceAll(RegExp(r'\s+'), '');
    if (cleaned.length != 6) return false;

    final now = DateTime.now().millisecondsSinceEpoch;
    // Allow current interval, previous interval, and next interval (skew tolerance)
    final timeOffsets = [0, -interval * 1000, interval * 1000];

    for (final offset in timeOffsets) {
      final validCode = OTP.generateTOTPCodeString(
        secret,
        now + offset,
        interval: interval,
        length: 6,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );
      if (validCode == cleaned) {
        return true;
      }
    }
    return false;
  }

  /// Returns the otpauth:// URI to generate a QR code for Google Authenticator.
  static String getOtpAuthUri({
    String accountName = 'admin@resto.eg',
    String issuer = 'Resto Admin Portal',
    String secret = defaultAdminSecret,
  }) {
    return 'otpauth://totp/$issuer:$accountName?secret=$secret&issuer=$issuer&algorithm=SHA1&digits=6&period=30';
  }
}
