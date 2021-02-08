import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import './loading_widget.dart';
import '../providers/cart_provider.dart';
import './dialog_widget.dart' as DialogWidget;
import '../screens/product_detail_screen.dart';
import '../providers/product_provider.dart';

class ProductItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    final cartProvider = Provider.of<CartProvider>(
      context,
      listen: false,
    );
    final _loading = GlobalKey<LoadingWidgetState>();

    return LoadingWidget(
      key: _loading,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: GridTile(
          child: GestureDetector(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
            onTap: () => Navigator.of(context).pushNamed(
              ProductDetailScreen.route,
              arguments: product,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<ProductProvider>(
              builder: (ctx, product, child) => IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () async {
                  try {
                    _loading.currentState.showLoading();
                    await product.toogleFavorite();
                    await Provider.of<ProductsProvider>(context, listen: false)
                        .fetchProducts();
                  } catch (error) {
                    DialogWidget.showErrorDialog(
                        error: error, context: context);
                  } finally {
                    _loading.currentState.closeLoading();
                  }
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cartProvider.addItem(product);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added product to cart!',
                    ),
                    duration: Duration(
                      seconds: 2,
                    ),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () => cartProvider.undoAddItem(product),
                    ),
                  ),
                );
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
