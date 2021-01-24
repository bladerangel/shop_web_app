// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  return CartItem(
    id: json['id'] as int,
    product: json['product'] == null
        ? null
        : ProductProvider.fromJson(json['product'] as Map<String, dynamic>),
    quantity: json['quantity'] as int,
  );
}

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'id': instance.id,
      'product': instance.product,
      'quantity': instance.quantity,
    };

CartProvider _$CartProviderFromJson(Map<String, dynamic> json) {
  return CartProvider(
    cartItems: (json['cartItems'] as List)
        ?.map((e) =>
            e == null ? null : CartItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CartProviderToJson(CartProvider instance) =>
    <String, dynamic>{
      'cartItems': instance.cartItems,
    };
