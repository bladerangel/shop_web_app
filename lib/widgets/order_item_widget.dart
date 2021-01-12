import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders_provider.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderItem order;

  const OrderItemWidget({
    Key key,
    @required this.order,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              '\$${order.cart.totalAmount}',
            ),
            subtitle: Text(
              DateFormat('dd MM yyyy hh:mm').format(order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
