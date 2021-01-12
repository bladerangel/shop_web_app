import 'package:flutter/foundation.dart';
import './product_provider.dart';

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
  List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  int get itemCount => _items.length;

  double get totalAmount => _items.fold(
      0.0,
      (previous, current) =>
          previous + current.product.price * current.quantity);

  void addItem(ProductProvider product) {
    int index = _items.indexWhere((item) => item.product == product);

    if (index != -1) {
      final item = _items[index];
      _items[index] = CartItem(
        id: item.id,
        product: item.product,
        quantity: item.quantity + 1,
      );
    } else {
      _items.add(
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch,
          product: product,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(CartItem cartItem) {
    _items.remove(cartItem);
    notifyListeners();
  }
}
