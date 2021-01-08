import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders_provider.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/order-screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future<void> _fetchOrders(BuildContext context) async {
    await Provider.of<OrdersProvider>(context, listen: false).getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: _fetchOrders(context),
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
                return Consumer<OrdersProvider>(
                  builder: (ctx, orderData, child) =>
                      orderData.orders.length <= 0
                          ? Center(
                              child: Text('No Orders'),
                            )
                          : ListView.builder(
                              itemCount: orderData.orders.length,
                              itemBuilder: (context, index) => OrderItemWidget(
                                orderData.orders[index],
                              ),
                            ),
                );
              }
            }
          }),
    );
  }
}
