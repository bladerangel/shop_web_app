// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductProvider _$ProductProviderFromJson(Map<String, dynamic> json) {
  return ProductProvider(
    id: json['id'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    price: (json['price'] as num)?.toDouble(),
    imageUrl: json['imageUrl'] as String,
    isFavorite: json['isFavorite'] as bool,
  );
}

Map<String, dynamic> _$ProductProviderToJson(ProductProvider instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'isFavorite': instance.isFavorite,
    };
