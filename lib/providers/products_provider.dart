import 'package:flutter/material.dart';
import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _itemsProvider = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageURL:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageURL:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageURL:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageURL:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
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

  void addProduct(Product product) {
    final newProduct = Product(
      id: DateTime.now().toString(),
      title: product.title,
      description: product.description,
      price: product.price,
      imageURL: product.imageURL,
    );
    _itemsProvider.add(newProduct);
    // _itemsProvider.insert(0, newProduct); //if you want to insert it to the beginning
    notifyListeners();
  }

  void editProduct(String id, Product newProduct) {
    final productIndex = _itemsProvider.indexWhere((item) => item.id == id);
    if (productIndex >= 0) {
      _itemsProvider[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('asdsa');
    }
  }

  void deleteProduct(String id) {
    _itemsProvider.removeWhere((item) => item.id == id);
    notifyListeners();
  }
  // Product({});
}
