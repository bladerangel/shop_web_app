import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import './http_provider.dart';

part 'product_provider.g.dart';

@JsonSerializable()
class ProductProvider with ChangeNotifier {
  final int id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool _isFavorite;

  ProductProvider({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    bool isFavorite,
  }) : _isFavorite = isFavorite ?? false;

  bool get isFavorite => _isFavorite;

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

  final _httpRequest = HttpProvider.instance.client;

  final _url = '/product';

  Future<void> toogleFavorite() async {
    try {
      final updatedProduct = copy(isFavorite: !isFavorite);
      await _httpRequest.post('$_url/favorite', data: updatedProduct.toJson());
      _isFavorite = !isFavorite;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
