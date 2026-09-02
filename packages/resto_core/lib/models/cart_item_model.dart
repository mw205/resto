import 'package:equatable/equatable.dart';
import 'product_model.dart';

class CartItemModel extends Equatable {
  final ProductModel product;
  final int quantity;
  final String specialInstructions;

  const CartItemModel({
    required this.product,
    this.quantity = 1,
    this.specialInstructions = '',
  });

  double get totalPrice => product.price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int? ?? 1,
      specialInstructions: json['specialInstructions'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'specialInstructions': specialInstructions,
    };
  }

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
    String? specialInstructions,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  @override
  List<Object?> get props => [product, quantity, specialInstructions];
}
