import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './manage_edit_product_screen.dart';
import '../widgets/drawer_widget.dart';
import '../providers/products_provider.dart';
import '../widgets/manage_product_widget.dart';

class ManageProductsScreen extends StatelessWidget {
  static const route = '/manage_products';

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Products',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(ManageEditProductScreen.route),
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: RefreshIndicator(
        onRefresh: productsProvider.fetchProducts,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsProvider.products.length,
            itemBuilder: (ctx, index) => Column(
              children: [
                ManageProductWidget(
                  product: productsProvider.products[index],
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
