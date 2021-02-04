import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import './http_provider.dart';
import './cart_provider.dart';

part 'orders_provider.g.dart';

@JsonSerializable()
class OrderItem {
  final int id;
  final CartProvider cart;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.cart,
    @required this.dateTime,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders;

  List<OrderItem> get orders => [..._orders];

  OrdersProvider({
    List<OrderItem> orders,
  }) : _orders = orders ?? [];

  final _httpRequest = HttpProvider.instance.client;
  final _url = '/order';

  Future<void> addOrder(CartProvider cart) async {
    final order = OrderItem(
      id: null,
      cart: cart,
      dateTime: DateTime.now(),
    );
    await _httpRequest.post(_url, data: order.toJson());
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    try {
      final response = await _httpRequest.get(_url);
      final List<dynamic> data = response.data;
      print(data);
      _orders = data.map((product) => OrderItem.fromJson(product)).toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
