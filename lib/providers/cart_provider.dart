import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import './product_provider.dart';

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
  List<CartItem> _cartItems;

  List<CartItem> get cartItems => [..._cartItems];

  CartProvider({
    List<CartItem> cartItems,
  }) : _cartItems = cartItems ?? [];

  factory CartProvider.fromJson(Map<String, dynamic> json) =>
      _$CartProviderFromJson(json);
  Map<String, dynamic> toJson() => _$CartProviderToJson(this);

  int get itemCount => _cartItems.length;

  double get totalAmount => _cartItems.fold(
      0.0,
      (previous, current) =>
          previous + current.product.price * current.quantity);

  void addItem(ProductProvider product) {
    int index = _cartItems.indexWhere((item) => item.product == product);
    if (index == -1) {
      _cartItems.add(
        CartItem(
          id: null,
          product: product,
          quantity: 1,
        ),
      );
    } else {
      _cartItems[index] =
          _cartItems[index].copy(quantity: _cartItems[index].quantity + 1);
    }

    notifyListeners();
  }

  void undoAddItem(ProductProvider product) {
    int index = _cartItems.indexWhere((item) => item.product == product);
    if (index == -1) {
      return;
    }

    if (_cartItems[index].quantity > 1) {
      _cartItems[index] =
          _cartItems[index].copy(quantity: _cartItems[index].quantity - 1);
    } else {
      _cartItems.remove(_cartItems[index]);
    }

    notifyListeners();
  }

  void removeItem(CartItem cartItem) {
    _cartItems.remove(cartItem);
    notifyListeners();
  }

  void clear() {
    _cartItems.clear();
    notifyListeners();
  }
}
