import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './dialog_widget.dart' as DialogWidget;
import './loading_widget.dart';
import '../providers/products_provider.dart';
import '../providers/product_provider.dart';
import '../screens/manage_edit_product_screen.dart';

class ManageProductWidget extends StatefulWidget {
  final ProductProvider product;

  const ManageProductWidget({
    Key key,
    @required this.product,
  }) : super(key: key);

  @override
  _ManageProductWidgetState createState() => _ManageProductWidgetState();
}

class _ManageProductWidgetState extends State<ManageProductWidget> {
  final _loading = GlobalKey<LoadingWidgetState>();

  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
      key: _loading,
      child: ListTile(
        title: Text(
          widget.product.title,
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            widget.product.imageUrl,
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
                  arguments: widget.product,
                ),
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  try {
                    _loading.currentState.showLoading();
                    final ProductsProvider productsProvider =
                        Provider.of<ProductsProvider>(context, listen: false);
                    await productsProvider.deleteProduct(widget.product);
                  } catch (error) {
                    DialogWidget.showErrorDialog(
                        error: error, context: context);
                  } finally {
                    _loading.currentState.closeLoading();
                  }
                },
                color: Theme.of(context).errorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
