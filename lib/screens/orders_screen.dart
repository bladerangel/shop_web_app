import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/dialog_widget.dart' as DialogWidget;
import '../widgets/loading_widget.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/order_item_widget.dart';
import '../providers/orders_provider.dart';

class OrderScreen extends StatefulWidget {
  static const route = '/orders';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _loading = GlobalKey<LoadingWidgetState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        _loading.currentState.showLoading();
        await Provider.of<OrdersProvider>(context, listen: false).fetchOrders();
      } catch (error) {
        print(error);
        DialogWidget.showErrorDialog(error: error, context: context);
      } finally {
        _loading.currentState.closeLoading();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders',
        ),
      ),
      drawer: DrawerWidget(),
      body: LoadingWidget(
        key: _loading,
        child: ListView.builder(
          itemCount: ordersProvider.orders.length,
          itemBuilder: (ctx, index) => OrderItemWidget(
            order: ordersProvider.orders[index],
          ),
        ),
      ),
    );
  }
}
