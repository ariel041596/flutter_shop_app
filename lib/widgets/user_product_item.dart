import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatefulWidget {
  final String id;
  final String title;
  final String imageURL;

  UserProductItem(
    this.id,
    this.title,
    this.imageURL,
  );

  @override
  _UserProductItemState createState() => _UserProductItemState();
}

class _UserProductItemState extends State<UserProductItem> {
  var _isLoading = false;

  Future<void> _deleteProduct() async {
    final scaffold = Scaffold.of(context);
    return showDialog(
      //add await here replace the return
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to remove item from the cart ?'),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () async {
              Navigator.of(ctx).pop(true);
              try {
                await Provider.of<ProductsProvider>(
                  context,
                  listen: false,
                ).deleteProduct(widget.id);
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text(
                      'Successfully deleted',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } catch (err) {
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text('Cannot delete'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.imageURL),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    EditProductScreen.routeName,
                    arguments: widget.id,
                  );
                }),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: _deleteProduct,
            ),
          ],
        ),
      ),
    );
  }
}
