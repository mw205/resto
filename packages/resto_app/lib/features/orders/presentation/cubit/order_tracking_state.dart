import 'package:equatable/equatable.dart';
import '../../data/models/order_model.dart';

class TrackingStep extends Equatable {
  final OrderStatus status;
  final String title;
  final String description;
  final bool isCompleted;
  final bool isCurrent;

  const TrackingStep({
    required this.status,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.isCurrent,
  });

  @override
  List<Object?> get props => [status, title, description, isCompleted, isCurrent];
}

class OrderTrackingState extends Equatable {
  final bool isLoading;
  final OrderModel? order;
  final List<TrackingStep> steps;
  final String? errorMessage;

  const OrderTrackingState({
    this.isLoading = false,
    this.order,
    this.steps = const [],
    this.errorMessage,
  });

  OrderTrackingState copyWith({
    bool? isLoading,
    OrderModel? order,
    List<TrackingStep>? steps,
    String? errorMessage,
  }) {
    return OrderTrackingState(
      isLoading: isLoading ?? this.isLoading,
      order: order ?? this.order,
      steps: steps ?? this.steps,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, order, steps, errorMessage];
}
