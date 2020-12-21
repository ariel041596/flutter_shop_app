import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart_provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // // final String description;
  // final double price;
  // final String imageURL;
  // // bool isFavorite;

  // ProductItem(
  //   this.id,
  //   this.title,
  //   // this.description,
  //   this.price,
  //   this.imageURL,
  //   // this.isFavorite,
  // );

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen: false,
    );
    final cart = Provider.of<CartProvider>(
      context,
      listen: false,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GridTile(
        child: GestureDetector(
          onTap: () => {
            Navigator.of(context)
                .pushNamed(ProductDetailScreen.routeName, arguments: {
              'id': product.id,
              'title': product.title,
            }),
          },
          child: Image.network(
            product.imageURL,
            fit: BoxFit.cover,
          ),
        ),
        header: Container(
          margin: EdgeInsets.only(
            top: 20,
          ),
          child: Center(
            child: Text(
              product.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black26,
          leading: Consumer<Product>(
            builder: (context, product, child) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).errorColor,
              onPressed: () {
                product.toggleFavoriteStatus();
              },
            ),
          ),
          title: Text(
            product.price.toString(),
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addItem(product.id, product.title, product.price);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added item to cart',
                      // textAlign: TextAlign.center,
                    ),
                    duration: Duration(
                      seconds: 2,
                    ),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.undo(product.id);
                      },
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
