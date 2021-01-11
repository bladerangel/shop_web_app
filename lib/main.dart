import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/products_provider.dart';
import './screens/product_detail_screen.dart';
import './screens/products_screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ProductsProvider(),
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
        },
      ),
    );
  }
}
