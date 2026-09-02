import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'حدث خطأ أثناء الاتصال بالسيرفر']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'حدث خطأ في استرجاع البيانات المؤقتة']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'بيانات الاعتماد غير صالحة أو منتهية']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
