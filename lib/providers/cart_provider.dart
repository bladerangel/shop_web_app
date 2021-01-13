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
}

class CartProvider with ChangeNotifier {
  CartProvider copy() {
    CartProvider cartProvider = CartProvider();
    cartProvider._items = items;
    return cartProvider;
  }

  List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  int get itemCount => _items.length;

  double get totalAmount => _items.fold(
      0.0,
      (previous, current) =>
          previous + current.product.price * current.quantity);

  void addItem(ProductProvider product) {
    int index = _items.indexWhere((item) => item.product == product);

    if (index == -1) {
      _items.add(
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch,
          product: product,
          quantity: 1,
        ),
      );
    } else {
      _items[index] = _items[index].copy(quantity: _items[index].quantity + 1);
    }

    notifyListeners();
  }

  void undoAddItem(ProductProvider product) {
    int index = _items.indexWhere((item) => item.product == product);
    if (index == -1) {
      return;
    }

    if (_items[index].quantity > 1) {
      _items[index] = _items[index].copy(quantity: _items[index].quantity - 1);
    } else {
      _items.remove(_items[index]);
    }

    notifyListeners();
  }

  void removeItem(CartItem cartItem) {
    _items.remove(cartItem);
    notifyListeners();
  }

  void clear() {
    _items = [];
    notifyListeners();
  }
}
