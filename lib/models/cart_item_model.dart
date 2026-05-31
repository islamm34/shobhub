import 'package:hive/hive.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 0)  // ✅ يبقى 0
class CartItemModel {
  @HiveField(0)
  final int id;

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
}