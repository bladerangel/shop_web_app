import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_web_app/providers/products_provider.dart';
import './product_item_widget.dart';

class ProductsGridWidget extends StatelessWidget {
  final bool showOnlyFavorites;

  const ProductsGridWidget({
    Key key,
    this.showOnlyFavorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = (showOnlyFavorites
        ? productsProvider.favoriteProducts
        : productsProvider.products);
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItemWidget(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
