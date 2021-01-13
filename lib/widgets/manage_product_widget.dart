import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../providers/product_provider.dart';
import '../screens/manage_edit_product_screen.dart';

class ManageProductWidget extends StatelessWidget {
  final ProductProvider product;

  const ManageProductWidget({
    Key key,
    @required this.product,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        product.title,
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          product.imageUrl,
        ),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                ManageEditProductScreen.route,
                arguments: product,
              ),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                final ProductsProvider productsProvider =
                    Provider.of<ProductsProvider>(context, listen: false);
                productsProvider.deleteProduct(product);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
