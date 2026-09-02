import 'package:equatable/equatable.dart';
import 'package:resto_core/resto_core.dart';

enum AdminAuthStep { credentials, totpVerification, authenticated }

class AdminAuthState extends Equatable {
  final AdminAuthStep step;
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;
  final String pendingEmail;
  final String totpSecret;

  const AdminAuthState({
    this.step = AdminAuthStep.credentials,
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.pendingEmail = '',
    this.totpSecret = TotpAuthenticator.defaultAdminSecret,
  });

  AdminAuthState copyWith({
    AdminAuthStep? step,
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    String? pendingEmail,
    String? totpSecret,
  }) {
    return AdminAuthState(
      step: step ?? this.step,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      pendingEmail: pendingEmail ?? this.pendingEmail,
      totpSecret: totpSecret ?? this.totpSecret,
    );
  }

  @override
  List<Object?> get props => [step, user, isLoading, errorMessage, pendingEmail, totpSecret];
}
