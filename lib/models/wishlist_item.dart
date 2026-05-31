import 'package:hive/hive.dart';
import 'product_model.dart';

part 'wishlist_item.g.dart';

@HiveType(typeId: 1)  // ✅ تغيير إلى 1 (يختلف عن CartItemModel)
class WishlistItem {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String thumbnail;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final double discountPercentage;

  @HiveField(5)
  final double rating;

  @HiveField(6)
  final int reviewCount;

  @HiveField(7)
  final DateTime addedDate;

  WishlistItem({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.reviewCount,
    required this.addedDate,
  });

  double get discountedPrice {
    return price * ((100 - discountPercentage) / 100);
  }

  int get discountPercent => discountPercentage.toInt();

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'reviewCount': reviewCount,
      'addedDate': addedDate.toIso8601String(),
    };
  }

  factory WishlistItem.fromFirestore(
      Map<String, dynamic> data,
      String documentId,
      ) {
    return WishlistItem(
      id: data['id'] as int,
      title: data['title'] as String,
      thumbnail: data['thumbnail'] as String,
      price: (data['price'] as num).toDouble(),
      discountPercentage: (data['discountPercentage'] as num).toDouble(),
      rating: (data['rating'] as num).toDouble(),
      reviewCount: data['reviewCount'] as int,
      addedDate: DateTime.parse(data['addedDate']),
    );
  }

  factory WishlistItem.fromProductModel(ProductModel product) {
    return WishlistItem(
      id: product.id ?? 0,
      title: product.title ?? '',
      thumbnail: product.thumbnail ?? '',
      price: product.price ?? 0,
      discountPercentage: product.discountPercentage ?? 0,
      rating: product.rating ?? 0,
      reviewCount: product.reviewCount,
      addedDate: DateTime.now(),
    );
  }
}