import 'package:equatable/equatable.dart';

class CouponModel extends Equatable {
  final String code;
  final double discountPercentage;
  final double? fixedDiscountAmount;
  final double maxDiscount;
  final double minOrderValue;
  final DateTime expiryDate;
  final bool isFixed;

  const CouponModel({
    required this.code,
    this.discountPercentage = 0.0,
    this.fixedDiscountAmount,
    this.maxDiscount = 100.0,
    this.minOrderValue = 50.0,
    required this.expiryDate,
    this.isFixed = false,
  });

  double calculateDiscount(double subtotal) {
    if (subtotal < minOrderValue) return 0.0;
    if (isFixed && fixedDiscountAmount != null) {
      return fixedDiscountAmount!.clamp(0.0, subtotal);
    }
    final discount = subtotal * (discountPercentage / 100.0);
    return discount > maxDiscount ? maxDiscount : discount;
  }

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      code: json['code'] as String? ?? '',
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      fixedDiscountAmount: (json['fixedDiscountAmount'] as num?)?.toDouble(),
      maxDiscount: (json['maxDiscount'] as num?)?.toDouble() ?? 100.0,
      minOrderValue: (json['minOrderValue'] as num?)?.toDouble() ?? 50.0,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : DateTime.now().add(const Duration(days: 30)),
      isFixed: json['isFixed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discountPercentage': discountPercentage,
      'fixedDiscountAmount': fixedDiscountAmount,
      'maxDiscount': maxDiscount,
      'minOrderValue': minOrderValue,
      'expiryDate': expiryDate.toIso8601String(),
      'isFixed': isFixed,
    };
  }

  @override
  List<Object?> get props => [
        code,
        discountPercentage,
        fixedDiscountAmount,
        maxDiscount,
        minOrderValue,
        expiryDate,
        isFixed,
      ];
}
