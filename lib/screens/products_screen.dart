import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/dialog_widget.dart' as DialogWidget;
import '../widgets/loading_widget.dart';
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
  final _loading = GlobalKey<LoadingWidgetState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        _loading.currentState.showLoading();
        await Provider.of<ProductsProvider>(context, listen: false)
            .fetchProducts();
      } catch (error) {
        DialogWidget.showErrorDialog(error: error, context: context);
      } finally {
        _loading.currentState.closeLoading();
      }
    });
    super.initState();
  }

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
      body: LoadingWidget(
        key: _loading,
        child: ProductsGridWidget(
          showOnlyFavorites: _showOnlyFavorites,
        ),
      ),
    );
  }
}
