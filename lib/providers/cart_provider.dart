import 'package:flutter/foundation.dart';
import './product_provider.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_provider.g.dart';

@JsonSerializable()
class CartItem {
  final int id;
  final ProductProvider product;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.product,
    @required this.quantity,
  });

  CartItem copy({
    int id,
    ProductProvider product,
    int quantity,
  }) =>
      CartItem(
        id: id ?? this.id,
        product: product ?? this.product,
        quantity: quantity ?? this.quantity,
      );

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}

@JsonSerializable()
class CartProvider with ChangeNotifier {
  final List<CartItem> cartItems;

  CartProvider({
    List<CartItem> cartItems,
  }) : this.cartItems = cartItems ?? [];

  factory CartProvider.fromJson(Map<String, dynamic> json) =>
      _$CartProviderFromJson(json);
  Map<String, dynamic> toJson() => _$CartProviderToJson(this);

  int get itemCount => cartItems.length;

  double get totalAmount => cartItems.fold(
      0.0,
      (previous, current) =>
          previous + current.product.price * current.quantity);

  void addItem(ProductProvider product) {
    int index = cartItems.indexWhere((item) => item.product == product);

    if (index == -1) {
      cartItems.add(
        CartItem(
          id: null,
          product: product,
          quantity: 1,
        ),
      );
    } else {
      cartItems[index] =
          cartItems[index].copy(quantity: cartItems[index].quantity + 1);
    }

    notifyListeners();
  }

  void undoAddItem(ProductProvider product) {
    int index = cartItems.indexWhere((item) => item.product == product);
    if (index == -1) {
      return;
    }

    if (cartItems[index].quantity > 1) {
      cartItems[index] =
          cartItems[index].copy(quantity: cartItems[index].quantity - 1);
    } else {
      cartItems.remove(cartItems[index]);
    }

    notifyListeners();
  }

  void removeItem(CartItem cartItem) {
    cartItems.remove(cartItem);
    notifyListeners();
  }

  void clear() {
    cartItems.clear();
    notifyListeners();
  }
}
