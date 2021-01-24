import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import './product_provider.dart';

class ProductsProvider with ChangeNotifier {
  /* [
    ProductProvider(
      id: 1,
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://5.imimg.com/data5/XP/PH/MY-57047128/round-neck-t-shirt-500x500.jpg',
    ),
    ProductProvider(
      id: 2,
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    ProductProvider(
      id: 3,
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    ProductProvider(
      id: 4,
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];*/

  final List<ProductProvider> products;

  final Dio _dio = Dio();

  final _url = 'http://localhost:8080/product';

  ProductsProvider({
    List<ProductProvider> products,
  }) : this.products = products ?? [];

  List<ProductProvider> get favoriteProducts => products
      .where(
        (product) => product.isFavorite,
      )
      .toList();

  Future<void> fetchProducts() async {
    try {
      final response = await _dio.get(_url);
      final List<dynamic> data = response.data;
      products.clear();
      products.addAll(data.map((product) => ProductProvider.fromJson(product)));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(
    ProductProvider product,
  ) async {
    try {
      await _dio.post(_url, data: product.toJson());
      await fetchProducts();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(
    ProductProvider product,
  ) async {
    try {
      await _dio.put('$_url/${product.id}', data: product.toJson());
      await fetchProducts();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(
    ProductProvider product,
  ) async {
    try {
      await _dio.delete('$_url/${product.id}');
      await fetchProducts();
    } catch (error) {
      throw error;
    }
  }
}
