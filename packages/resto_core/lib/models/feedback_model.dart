import 'package:equatable/equatable.dart';

class OrderFeedbackModel extends Equatable {
  final String id;
  final String orderId;
  final double rating;
  final List<String> selectedTags;
  final String comment;
  final DateTime createdAt;

  const OrderFeedbackModel({
    required this.id,
    required this.orderId,
    required this.rating,
    this.selectedTags = const [],
    required this.comment,
    required this.createdAt,
  });

  factory OrderFeedbackModel.fromJson(Map<String, dynamic> json) {
    return OrderFeedbackModel(
      id: json['id'] as String? ?? '',
      orderId: json['orderId'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      selectedTags: (json['selectedTags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      comment: json['comment'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'rating': rating,
      'selectedTags': selectedTags,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, orderId, rating, selectedTags, comment, createdAt];
}

class ComplaintModel extends Equatable {
  final String id;
  final String? orderId;
  final String subject;
  final String message;
  final String status;
  final DateTime createdAt;

  const ComplaintModel({
    required this.id,
    this.orderId,
    required this.subject,
    required this.message,
    this.status = 'قيد المراجعة',
    required this.createdAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'] as String? ?? '',
      orderId: json['orderId'] as String?,
      subject: json['subject'] as String? ?? '',
      message: json['message'] as String? ?? '',
      status: json['status'] as String? ?? 'قيد المراجعة',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'subject': subject,
      'message': message,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, orderId, subject, message, status, createdAt];
}
