import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_provider.g.dart';

@JsonSerializable()
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

  factory ProductProvider.fromJson(Map<String, dynamic> json) =>
      _$ProductProviderFromJson(json);
  Map<String, dynamic> toJson() => _$ProductProviderToJson(this);

  void toogleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
