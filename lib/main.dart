import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/orders_screen.dart';
import './providers/orders_provider.dart';
import './screens/cart_screen.dart';
import './providers/cart_provider.dart';
import './providers/products_provider.dart';
import './screens/product_detail_screen.dart';
import './screens/products_screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ProductsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CartProvider(),
        ),
        ChangeNotifierProvider.value(
          value: OrdersProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Shop Web App',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsScreen(),
        routes: {
          ProductDetailScreen.route: (ctx) => ProductDetailScreen(),
          CartScreen.route: (ctx) => CartScreen(),
          OrderScreen.route: (ctx) => OrderScreen(),
        },
      ),
    );
  }
}
