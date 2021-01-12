import 'package:flutter/foundation.dart';
import 'package:shop_web_app/providers/product_provider.dart';

class CartItem {
  final int id;
  final ProductProvider product;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.product,
    @required this.quantity,
  });
}

class CartProvider with ChangeNotifier {
  Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount => _items.values.fold(
      0.0,
      (previous, current) =>
          previous + current.product.price * current.quantity);

  void addItem(ProductProvider product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (item) => CartItem(
          id: item.id,
          product: item.product,
          quantity: item.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: DateTime.now().millisecondsSinceEpoch,
          product: product,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }
}
