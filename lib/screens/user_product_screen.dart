import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .getProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<ProductsProvider>(context);
    print('rebuilds');
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: _refreshProduct(context),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text('An error Occured'),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: () => _refreshProduct(context),
                  child: Consumer<ProductsProvider>(
                    builder: (ctx, productsData, child) => Padding(
                      padding: EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount: productsData.itemsProvider.length,
                        itemBuilder: (context, index) => Column(
                          children: <Widget>[
                            UserProductItem(
                              productsData.itemsProvider[index].id,
                              productsData.itemsProvider[index].title,
                              productsData.itemsProvider[index].imageURL,
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
          }),
    );
  }
}
