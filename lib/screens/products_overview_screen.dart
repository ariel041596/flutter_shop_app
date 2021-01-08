import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'products_overview_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart_provider.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products_provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverViewScreen extends StatefulWidget {
  static const routeName = '/products-overview';

  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _showOnlyFavorites = false;
  var _showAll = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<ProductsProvider>(context).getProducts(); //Wont work

    // Will work
    // Future.delayed(Duration.zero).then(
    //   (value) => Provider.of<ProductsProvider>(context, listen: false).getProducts(),
    // );
    super.initState();
  }

  //Todo this is the original code
  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     Provider.of<ProductsProvider>(context).getProducts().then((value) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }
  //Todo End this is the original code //End

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<ProductsProvider>(
    //   context,
    //   listen: false,
    // );

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Shopilore',
          ),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    // productsData.showFavoritesOnly();
                    _showOnlyFavorites = true;
                  } else {
                    // productsData.showAll();
                    _showOnlyFavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.All,
                ),
              ],
            ),
            Consumer<CartProvider>(
              builder: (context, cartData, ch) => Badge(
                child: ch,
                value: cartData.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body:
            //Todo this is the original code and uncomment the didChangeDependencies
            // _isLoading
            //           ? Center(
            //               child: CircularProgressIndicator(),
            //             )
            // : ProductsGrid(_showOnlyFavorites),
            FutureBuilder(
          future: Provider.of<ProductsProvider>(context, listen: false)
              .getProducts(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text('An error occured'),
                );
              } else {
                return ProductsGrid(_showOnlyFavorites);
              }
            }
          },
        ));
  }
}
