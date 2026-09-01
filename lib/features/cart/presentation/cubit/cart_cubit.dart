import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/mock_resto_api.dart';
import '../../../menu/data/models/product_model.dart';
import '../../../orders/data/models/order_model.dart';
import '../../data/models/cart_item_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final MockRestoApi _api;

  CartCubit(this._api) : super(const CartState());

  void addToCart(ProductModel product, {int quantity = 1, String specialInstructions = ''}) {
    final currentItems = List<CartItemModel>.from(state.items);
    final existingIndex = currentItems.indexWhere((i) =>
        i.product.id == product.id && i.specialInstructions == specialInstructions);

    if (existingIndex != -1) {
      final existing = currentItems[existingIndex];
      currentItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    } else {
      currentItems.add(
        CartItemModel(
          product: product,
          quantity: quantity,
          specialInstructions: specialInstructions,
        ),
      );
    }

    emit(state.copyWith(items: currentItems));
  }

  void updateQuantity(CartItemModel item, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(item);
      return;
    }

    final currentItems = List<CartItemModel>.from(state.items);
    final index = currentItems.indexOf(item);
    if (index != -1) {
      currentItems[index] = item.copyWith(quantity: newQuantity);
      emit(state.copyWith(items: currentItems));
    }
  }

  void removeFromCart(CartItemModel item) {
    final currentItems = List<CartItemModel>.from(state.items);
    currentItems.remove(item);
    emit(state.copyWith(items: currentItems));
  }

  void setOrderType(OrderType type) {
    emit(state.copyWith(orderType: type));
  }

  void setDeliveryAddress(String address) {
    emit(state.copyWith(deliveryAddress: address));
  }

  void setPickupBranch(String branch) {
    emit(state.copyWith(pickupBranch: branch));
  }

  Future<void> applyCoupon(String couponCode) async {
    if (couponCode.trim().isEmpty) return;
    emit(state.copyWith(status: CartStatus.loading, clearCouponError: true));
    try {
      final coupon = await _api.validateCoupon(couponCode);
      if (coupon != null) {
        if (state.subtotal < coupon.minOrderValue) {
          emit(state.copyWith(
            status: CartStatus.error,
            couponError: 'الحد الأدنى للطلب لاستخدام هذا الكوبون هو ${coupon.minOrderValue} ج.م',
          ));
        } else {
          emit(state.copyWith(
            status: CartStatus.success,
            appliedCoupon: coupon,
            clearCouponError: true,
          ));
        }
      } else {
        emit(state.copyWith(
          status: CartStatus.error,
          couponError: 'كود الكوبون غير صحيح أو منتهي الصلاحية',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.error,
        couponError: 'حدث خطأ أثناء فحص الكوبون',
      ));
    }
  }

  void removeCoupon() {
    emit(state.copyWith(clearCoupon: true, clearCouponError: true));
  }

  void clearCart() {
    emit(const CartState());
  }
}
