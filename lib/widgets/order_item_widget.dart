import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders_provider.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;

  const OrderItemWidget({
    Key key,
    @required this.order,
  }) : super(key: key);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              '\$${widget.order.cart.totalAmount}',
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              height: min(widget.order.cart.itemCount * 20.0 + 10, 180),
              child: ListView(
                children: widget.order.cart.cartItems
                    .map((item) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.product.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${item.quantity} x \$${item.product.price}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
