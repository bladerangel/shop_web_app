import 'package:flutter/foundation.dart';

class ProductProvider with ChangeNotifier {
  final int id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductProvider({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  ProductProvider copy({
    int id,
    String title,
    String description,
    double price,
    String imageUrl,
    bool isFavorite,
  }) =>
      ProductProvider(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        isFavorite: isFavorite ?? this.isFavorite,
      );

  void toogleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
