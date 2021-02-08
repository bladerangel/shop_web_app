import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({
    Key key,
    @required this.cartItem,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(
      context,
      listen: false,
    );
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(
          right: 20,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Are you sure?',
          ),
          content: Text(
            'Do you want to remove the product from the cart?',
          ),
          actions: [
            FlatButton(
              child: Text(
                'No',
              ),
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
            FlatButton(
              child: Text(
                'Yes',
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
          ],
        ),
      ),
      onDismissed: (direction) => cartProvider.removeItem(cartItem),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text(
                    '\$${cartItem.product.price}',
                  ),
                ),
              ),
            ),
            title: Text(cartItem.product.title),
            subtitle:
                Text('Total: \$${cartItem.product.price * cartItem.quantity}'),
            trailing: Text('${cartItem.quantity} x'),
          ),
        ),
      ),
    );
  }
}
