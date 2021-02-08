import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/future_loading_widget.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/order_item_widget.dart';
import '../providers/orders_provider.dart';

class OrderScreen extends StatelessWidget {
  static const route = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders',
        ),
      ),
      drawer: DrawerWidget(),
      body: FutureLoadingWidget(
        onAction:
            Provider.of<OrdersProvider>(context, listen: false).fetchOrders(),
        child: Consumer<OrdersProvider>(
          builder: (ctx, ordersProvider, child) => ListView.builder(
            itemCount: ordersProvider.orders.length,
            itemBuilder: (ctx, index) => OrderItemWidget(
              order: ordersProvider.orders[index],
            ),
          ),
        ),
      ),
    );
  }
}
