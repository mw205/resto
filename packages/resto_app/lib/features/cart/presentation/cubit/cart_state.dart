import 'package:equatable/equatable.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/coupon_model.dart';
import '../../../orders/data/models/order_model.dart';

enum CartStatus { initial, loading, success, error }

class CartState extends Equatable {
  final CartStatus status;
  final List<CartItemModel> items;
  final OrderType orderType;
  final CouponModel? appliedCoupon;
  final String? couponError;
  final String deliveryAddress;
  final String pickupBranch;
  final double deliveryFee;

  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.orderType = OrderType.delivery,
    this.appliedCoupon,
    this.couponError,
    this.deliveryAddress = 'القاهرة - مصر الجديدة - شارع الثورة عمارة 14 الدور 3',
    this.pickupBranch = 'فرع التجمع الخامس - مول بوينت 90',
    this.deliveryFee = 25.0,
  });

  int get totalItemsCount => items.fold<int>(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold<double>(0.0, (sum, item) => sum + item.totalPrice);

  double get actualDeliveryFee => orderType == OrderType.delivery ? deliveryFee : 0.0;

  double get discountAmount {
    if (appliedCoupon == null) return 0.0;
    return appliedCoupon!.calculateDiscount(subtotal);
  }

  double get total {
    final t = subtotal - discountAmount + actualDeliveryFee;
    return t < 0.0 ? 0.0 : t;
  }

  bool get isEmpty => items.isEmpty;

  CartState copyWith({
    CartStatus? status,
    List<CartItemModel>? items,
    OrderType? orderType,
    CouponModel? appliedCoupon,
    bool clearCoupon = false,
    String? couponError,
    bool clearCouponError = false,
    String? deliveryAddress,
    String? pickupBranch,
    double? deliveryFee,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      orderType: orderType ?? this.orderType,
      appliedCoupon: clearCoupon ? null : (appliedCoupon ?? this.appliedCoupon),
      couponError: clearCouponError ? null : (couponError ?? this.couponError),
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      pickupBranch: pickupBranch ?? this.pickupBranch,
      deliveryFee: deliveryFee ?? this.deliveryFee,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        orderType,
        appliedCoupon,
        couponError,
        deliveryAddress,
        pickupBranch,
        deliveryFee,
      ];
}
