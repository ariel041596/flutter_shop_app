import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'cart_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String authToken;
  final String userID;
  OrdersProvider(this.authToken, this.userID, this._orders);

  Future<void> getOrders() async {
    final url =
        'https://flutter-shop-app-ea511-default-rtdb.firebaseio.com/orders/$userID.json?auth=$authToken';
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrder = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((orderID, orderData) {
        loadedOrder.add(OrderItem(
          id: orderID,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (order) => CartItem(
                  id: order['id'],
                  price: order['price'],
                  quantity: order['quantity'],
                  title: order['title'],
                ),
              )
              .toList(),
        ));
      });
      _orders = loadedOrder.reversed.toList();
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    var timeStamp = DateTime.now();
    final url =
        'https://flutter-shop-app-ea511-default-rtdb.firebaseio.com/orders/$userID.json?auth=$authToken';
    try {
      var response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cartProduct) => {
                    'id': cartProduct.id,
                    'title': cartProduct.title,
                    'quantity': cartProduct.quantity,
                    'price': cartProduct.price,
                  })
              .toList(),
        }),
      );
      if (!cartProducts.isEmpty) {
        _orders.insert(
          0,
          OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timeStamp,
          ),
        );
      }
      notifyListeners();
      // print(json.decode(response.body)); //return is Instance of 'Response'
      // final newOrder = OrderItem(
      //   id: json.decode(response.body)['name'], //return id = name:-MPCJasdsads
      //   amount: total,
      //   products: cartProducts,
      //   dateTime:,
      // );
      // _orders.add(newOrder);
      // _itemsProvider.insert(0, newProduct); //if you want to insert it to the beginning
    } catch (err) {
      print(err);
      throw err;
    }
  }
}
