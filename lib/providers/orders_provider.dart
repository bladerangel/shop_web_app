import 'package:flutter/foundation.dart';
import './cart_provider.dart';

class OrderItem {
  final int id;
  final CartProvider cart;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.cart,
    @required this.dateTime,
  });
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders => [..._orders];

  void addOrder(CartProvider cart) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().microsecondsSinceEpoch,
        cart: cart,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
