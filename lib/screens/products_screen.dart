import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/future_loading_widget.dart';
import '../providers/products_provider.dart';
import '../widgets/drawer_widget.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge_widget.dart';
import '../widgets/products_grid_widget.dart';

enum MenuOptions {
  Favorites,
  All,
}

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shop',
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: MenuOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: MenuOptions.All,
              ),
            ],
            onSelected: (value) {
              setState(() {
                switch (value) {
                  case MenuOptions.Favorites:
                    _showOnlyFavorites = true;
                    break;
                  case MenuOptions.All:
                    _showOnlyFavorites = false;
                    break;
                  default:
                    break;
                }
              });
            },
          ),
          Consumer<CartProvider>(
            builder: (ctx, cart, child) => BadgeWidget(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () => Navigator.of(context).pushNamed(
                CartScreen.route,
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: FutureLoadingWidget(
        onAction: Provider.of<ProductsProvider>(context, listen: false)
            .fetchProducts(),
        child: ProductsGridWidget(
          showOnlyFavorites: _showOnlyFavorites,
        ),
      ),
    );
  }
}
