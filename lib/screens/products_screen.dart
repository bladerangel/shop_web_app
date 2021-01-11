import 'package:flutter/material.dart';
import '../widgets/products_grid_widget.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shop',
        ),
      ),
      body: ProductsGridWidget(),
    );
  }
}
