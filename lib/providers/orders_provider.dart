import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
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
  final List<OrderItem> orders;

  OrdersProvider({
    List<OrderItem> orders,
  }) : this.orders = orders ?? [];

  final Dio _dio = Dio();
  final _url = 'http://localhost:8080/order';

  Future<void> addOrder(CartProvider cart) async {
    final order = OrderItem(
      id: null,
      cart: cart,
      dateTime: DateTime.now(),
    );

    await _dio.post(_url, data: order.toJson());
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    try {
      final response = await _dio.get(_url);
      final List<dynamic> data = response.data;
      orders.clear();
      orders
          .addAll(data.reversed.map((product) => OrderItem.fromJson(product)));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
