import 'package:hive/hive.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 2)
class CartItemModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int productId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String thumbnail;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final double discountPercentage;

  @HiveField(6)
  int quantity;

  @HiveField(7)
  final DateTime addedDate;

  @HiveField(8)
  final String userId;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.discountPercentage,
    this.quantity = 1,
    required this.addedDate,
    required this.userId,
  });

  double get discountedPrice => price * ((100 - discountPercentage) / 100);
  double get totalPrice => discountedPrice * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'thumbnail': thumbnail,
      'price': price,
      'discountPercentage': discountPercentage,
      'quantity': quantity,
      'addedDate': addedDate.toIso8601String(),
      'userId': userId,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['productId'].toString(),
      productId: map['productId'] as int,
      title: map['title'] as String,
      thumbnail: map['thumbnail'] as String,
      price: (map['price'] as num).toDouble(),
      discountPercentage: (map['discountPercentage'] as num).toDouble(),
      quantity: map['quantity'] as int,
      addedDate: DateTime.parse(map['addedDate']),
      userId: map['userId'] ?? '',
    );
  }
}