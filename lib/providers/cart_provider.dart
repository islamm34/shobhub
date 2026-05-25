import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/firestore_service.dart';
import '../models/product_model.dart';

final firestoreServiceProvider = Provider((ref) => FirestoreService());

// ✅ نموذج عنصر السلة
class CartItemModel {
  final int productId;
  final String title;
  final String thumbnail;
  final double price;
  final double discountPercentage;
  final int quantity;
  final DateTime addedDate;

  CartItemModel({
    required this.productId,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.discountPercentage,
    this.quantity = 1,
    required this.addedDate,
  });

  double get discountedPrice => price * ((100 - discountPercentage) / 100);
  double get totalPrice => discountedPrice * quantity;

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'] as int,
      title: map['title'] as String,
      thumbnail: map['thumbnail'] as String,
      price: (map['price'] as num).toDouble(),
      discountPercentage: (map['discountPercentage'] as num).toDouble(),
      quantity: map['quantity'] as int,
      addedDate: DateTime.parse(map['addedDate']),
    );
  }

  factory CartItemModel.fromProductModel(ProductModel product, {int quantity = 1}) {
    return CartItemModel(
      productId: product.id ?? 0,
      title: product.title ?? '',
      thumbnail: product.thumbnail ?? '',
      price: product.price ?? 0,
      discountPercentage: product.discountPercentage ?? 0,
      quantity: quantity,
      addedDate: DateTime.now(),
    );
  }
}

// ✅ Provider لقائمة الـ Cart
final cartItemsProvider = StreamProvider<List<CartItemModel>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getCartStream().map((cartList) {
    return cartList.map((item) => CartItemModel.fromMap(item)).toList();
  });
});

// ✅ Provider للتحكم في الـ Cart
final cartControllerProvider = Provider((ref) {
  return CartController(ref);
});

class CartController {
  final Ref ref;

  CartController(this.ref);

  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.addToCart(
      productId: product.id ?? 0,
      title: product.title ?? '',
      thumbnail: product.thumbnail ?? '',
      price: product.price ?? 0,
      discountPercentage: product.discountPercentage ?? 0,
      quantity: quantity,
    );

    // تحديث الـ Provider
    ref.invalidate(cartItemsProvider);
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.updateCartQuantity(productId, quantity);

    // تحديث الـ Provider
    ref.invalidate(cartItemsProvider);
  }

  Future<void> removeFromCart(int productId) async {
    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.removeFromCart(productId);

    // تحديث الـ Provider
    ref.invalidate(cartItemsProvider);
  }

  Future<void> clearCart() async {
    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.clearCart();

    // تحديث الـ Provider
    ref.invalidate(cartItemsProvider);
  }
}