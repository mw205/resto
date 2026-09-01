import 'package:flutter_test/flutter_test.dart';
import 'package:resto/core/network/mock_resto_api.dart';
import 'package:resto/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:resto/features/cart/presentation/cubit/cart_state.dart';
import 'package:resto/features/menu/data/models/product_model.dart';
import 'package:resto/features/orders/data/models/order_model.dart';

void main() {
  late MockRestoApi api;
  late CartCubit cartCubit;

  const testProduct = ProductModel(
    id: 'test_01',
    name: 'كشري مصري',
    description: 'كشري مصري بالدقة والصلصة',
    price: 50.0,
    imageUrl: 'https://example.com/koshary.jpg',
    categoryId: 'cat_koshary',
    categoryName: 'كشري',
  );

  setUp(() {
    api = MockRestoApi();
    cartCubit = CartCubit(api);
  });

  tearDown(() {
    cartCubit.close();
  });

  group('CartCubit Tests', () {
    test('initial state is empty with default delivery fee', () {
      expect(cartCubit.state.items, isEmpty);
      expect(cartCubit.state.totalItemsCount, 0);
      expect(cartCubit.state.subtotal, 0.0);
      expect(cartCubit.state.orderType, OrderType.delivery);
      expect(cartCubit.state.deliveryFee, 25.0);
    });

    test('adding product to cart increases count and subtotal', () {
      cartCubit.addToCart(testProduct, quantity: 2);

      expect(cartCubit.state.items.length, 1);
      expect(cartCubit.state.totalItemsCount, 2);
      expect(cartCubit.state.subtotal, 100.0);
      expect(cartCubit.state.total, 125.0); // 100 + 25 delivery fee
    });

    test('updating quantity changes total and removing when 0', () {
      cartCubit.addToCart(testProduct, quantity: 2);
      final item = cartCubit.state.items.first;

      cartCubit.updateQuantity(item, 3);
      expect(cartCubit.state.totalItemsCount, 3);
      expect(cartCubit.state.subtotal, 150.0);

      cartCubit.updateQuantity(cartCubit.state.items.first, 0);
      expect(cartCubit.state.items, isEmpty);
    });

    test('switching to takeaway sets delivery fee to 0', () {
      cartCubit.addToCart(testProduct, quantity: 1);
      expect(cartCubit.state.actualDeliveryFee, 25.0);

      cartCubit.setOrderType(OrderType.takeaway);
      expect(cartCubit.state.actualDeliveryFee, 0.0);
      expect(cartCubit.state.total, 50.0);
    });

    test('applying valid coupon RESTO20 calculates discount', () async {
      cartCubit.addToCart(testProduct, quantity: 4); // 200 EGP
      await cartCubit.applyCoupon('RESTO20'); // 20% discount (capped at 50)

      expect(cartCubit.state.appliedCoupon, isNotNull);
      expect(cartCubit.state.discountAmount, 40.0); // 20% of 200
      expect(cartCubit.state.total, 185.0); // 200 - 40 + 25
    });

    test('applying invalid coupon emits coupon error', () async {
      cartCubit.addToCart(testProduct, quantity: 2);
      await cartCubit.applyCoupon('INVALID_CODE');

      expect(cartCubit.state.appliedCoupon, isNull);
      expect(cartCubit.state.couponError, isNotNull);
      expect(cartCubit.state.status, CartStatus.error);
    });
  });
}
