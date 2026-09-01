import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'حدث خطأ أثناء الاتصال بالسيرفر']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'حدث خطأ في استرجاع البيانات المؤقتة']) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'بيانات الاعتماد غير صالحة أو منتهية']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
