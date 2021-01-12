import 'package:flutter/material.dart';
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
            },
          ),
        ],
      ),
      body: ProductsGridWidget(showOnlyFavorites: _showOnlyFavorites),
    );
  }
}
