import 'package:equatable/equatable.dart';

enum FeedbackStatus { initial, loading, success, error }

class FeedbackState extends Equatable {
  final FeedbackStatus status;
  final String? successMessage;
  final String? errorMessage;

  const FeedbackState({
    this.status = FeedbackStatus.initial,
    this.successMessage,
    this.errorMessage,
  });

  FeedbackState copyWith({
    FeedbackStatus? status,
    String? successMessage,
    String? errorMessage,
  }) {
    return FeedbackState(
      status: status ?? this.status,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, successMessage, errorMessage];
}
