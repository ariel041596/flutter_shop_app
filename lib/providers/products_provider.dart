import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import './product.dart';
import '../models/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _itemsProvider = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageURL:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageURL:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageURL:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageURL:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavoritesOnly = false;

  List<Product> get itemsProvider {
    // if (_showFavoritesOnly) {
    //   return _itemsProvider.where((item) => item.isFavorite).toList();
    // }
    return [..._itemsProvider];
  }

  List<Product> get favorites {
    return _itemsProvider.where((item) => item.isFavorite).toList();
  }

  Product findByID(String id) {
    return _itemsProvider.firstWhere((item) => item.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

/*
this is a future method
  Future<void> addProduct(Product product) {
    var url =
        'https://flutter-shop-app-ea511-default-rtdb.firebaseio.com/products.json';
    return http
        .post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageURL': product.imageURL,
        'isFavorite': product.isFavorite,
      }),
    )
        .then((response) {
      // print(json.decode(response.body)); //return is Instance of 'Response'
      final newProduct = Product(
        id: json.decode(response.body)['name'], //return id = name:-MPCJasdsads
        title: product.title,
        description: product.description,
        price: product.price,
        imageURL: product.imageURL,
      );
      _itemsProvider.add(newProduct);
      // _itemsProvider.insert(0, newProduct); //if you want to insert it to the beginning
      notifyListeners();
    }).catchError((err) {
      print(err);
      throw err;
    });
  }
  */

  final String authToken;
  final String userID;
  ProductsProvider(this.authToken, this.userID, this._itemsProvider);
  // This is an async that also a future method therefore remove the return in http
  Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-shop-app-ea511-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      var response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageURL': product.imageURL,
          'creatorID': userID
          // 'isFavorite': product.isFavorite,
        }),
      );
      // print(json.decode(response.body)); //return is Instance of 'Response'
      final newProduct = Product(
        id: json.decode(response.body)['name'], //return id = name:-MPCJasdsads
        title: product.title,
        description: product.description,
        price: product.price,
        imageURL: product.imageURL,
      );
      _itemsProvider.add(newProduct);
      // _itemsProvider.insert(0, newProduct); //if you want to insert it to the beginning
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> getProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorID"&equalTo="$userID"' : '';
    var url =
        'https://flutter-shop-app-ea511-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }
      url =
          'https://flutter-shop-app-ea511-default-rtdb.firebaseio.com/userFavorites/$userID.json?auth=$authToken';
      final favoriteProduct = await http.get(url);
      final favoriteData = json.decode(favoriteProduct.body);
      final List<Product> loadedProduct = [];
      extractedData.forEach((prodID, prodData) {
        loadedProduct.add(Product(
          id: prodID,
          description: prodData['description'],
          price: prodData['price'],
          title: prodData['title'],
          imageURL: prodData['imageURL'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodID] ?? false,
        ));
      });
      _itemsProvider = loadedProduct;
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> editProduct(String id, Product newProduct) async {
    final productIndex = _itemsProvider.indexWhere((item) => item.id == id);
    try {
      if (productIndex >= 0) {
        final url =
            'https://flutter-shop-app-ea511-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

        final response = await http.patch(
          url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageURL': newProduct.imageURL,
            'isFavorite': newProduct.isFavorite,
          }),
        );
        print(response.statusCode); //Todo test it here
        if (response.statusCode >= 400) {
          throw HttpException('Could not edit');
        }
        _itemsProvider[productIndex] = newProduct; // Todo try to comment
        notifyListeners();
      } else {
        print('asdsa');
      }
    } catch (err) {
      print(err);
      throw err;
    }
  }

// This method works
  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-shop-app-ea511-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex =
        _itemsProvider.indexWhere((product) => product.id == id);
    var existingProduct = _itemsProvider[existingProductIndex];
    // _itemsProvider.removeWhere((item) => item.id == id);
    _itemsProvider.removeAt(existingProductIndex);
    notifyListeners();
    // try{
    //    final response = await http.delete(url);
    // if (response.statusCode >= 400) {
    //   _itemsProvider.insert(existingProductIndex, existingProduct);
    //   notifyListeners();
    //   throw HttpException('Could not delete');
    // }
    // }catch(err){
    //    existingProduct = null;
    // }

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _itemsProvider.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete');
    }
    existingProduct = null;
  }
  // Product({});
}
