import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/database_service.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';
import 'auth_provider.dart';

final databaseServiceProvider = Provider((ref) => DatabaseService());

// ✅ Provider لقائمة السلة
final cartItemsProvider = FutureProvider<List<CartItemModel>>((ref) async {
  final dbService = ref.watch(databaseServiceProvider);
  final user = ref.watch(currentUserProvider);

  if (user == null) {
    return [];
  }

  final cart = await dbService.getCart(user.uid);
  print('📦 CartProvider: ${cart.length} items loaded');
  return cart;
});

// ✅ Provider للتحكم في السلة
final cartControllerProvider = Provider((ref) {
  return CartController(ref);
});

class CartController {
  final Ref ref;

  CartController(this.ref);

  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    final dbService = ref.read(databaseServiceProvider);
    final user = ref.read(currentUserProvider);

    if (user == null) {
      throw Exception('Please login to add to cart');
    }

    await dbService.addToCart(
      productId: product.id ?? 0,
      title: product.title ?? '',
      thumbnail: product.thumbnail ?? '',
      price: product.price ?? 0,
      discountPercentage: product.discountPercentage ?? 0,
      quantity: quantity,
      userId: user.uid,
    );

    // ✅ تحديث الـ Provider بعد الإضافة
    ref.invalidate(cartItemsProvider);
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    final dbService = ref.read(databaseServiceProvider);
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    await dbService.updateCartQuantity(productId, quantity, user.uid);
    ref.invalidate(cartItemsProvider);
  }

  Future<void> removeFromCart(int productId) async {
    final dbService = ref.read(databaseServiceProvider);
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    await dbService.removeFromCart(productId, user.uid);
    ref.invalidate(cartItemsProvider);
  }

  Future<void> clearCart() async {
    final dbService = ref.read(databaseServiceProvider);
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    await dbService.clearCart(user.uid);
    ref.invalidate(cartItemsProvider);
  }

  double calculateTotal(List<CartItemModel> cartItems) {
    return cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int calculateTotalItems(List<CartItemModel> cartItems) {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
}