import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/firestore_service.dart';
import '../models/product_model.dart';
import '../models/wishlist_item.dart';
import '../core/services/api_service.dart';

final firestoreServiceProvider = Provider((ref) => FirestoreService());

// ✅ Stream للمستخدم الحالي
final currentUserStreamProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// ✅ Provider لقائمة أسماء الـ Wishlist
final wishlistNamesProvider = StreamProvider<List<String>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final currentUser = ref.watch(currentUserStreamProvider).value;

  if (currentUser == null) {
    return Stream.value([]);
  }

  return firestoreService
      .getWishlistStream(); // ✅ الآن يعيد Stream<List<String>>
});

// ✅ Provider لقائمة الـ Wishlist كاملة (جلب المنتجات بالأسماء)
final wishlistItemsProvider = FutureProvider<List<WishlistItem>>((ref) async {
  final firestoreService = ref.watch(firestoreServiceProvider);

  final wishlistNamesAsync = ref.watch(wishlistNamesProvider);
  final wishlistNames = wishlistNamesAsync.valueOrNull ?? [];

  if (wishlistNames.isEmpty) return [];

  List<WishlistItem> items = [];
  for (String productName in wishlistNames) {
    try {
      // ✅ البحث عن المنتج بالاسم
      final searchResult = await ApiService().searchProducts(productName);
      if (searchResult != null && searchResult.products.isNotEmpty) {
        final product = searchResult.products.first;
        items.add(WishlistItem.fromProductModel(product));
      }
    } catch (e) {
      print('Error fetching product "$productName": $e');
    }
  }
  return items;
});


final wishlistControllerProvider = Provider((ref) {
  return WishlistController(ref);
});

class WishlistController {
  final Ref ref;

  WishlistController(this.ref);

  Future<void> addToWishlist(ProductModel product) async {
    if (product.title == null) return;

    final currentUser = ref.read(currentUserStreamProvider).value;
    if (currentUser == null) {
      throw Exception('Please login to add to wishlist');
    }
    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.addToWishlist(product.title!);
    ref.invalidate(wishlistNamesProvider);
    ref.invalidate(wishlistItemsProvider);
  }

  Future<void> removeFromWishlist(String productName) async {
    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.removeFromWishlist(productName);

    // تحديث الـ Provider
    ref.invalidate(wishlistNamesProvider);
    ref.invalidate(wishlistItemsProvider);
  }

  Future<void> clearWishlist() async {
    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.clearWishlist();
    // تحديث الـ Provider
    ref.invalidate(wishlistNamesProvider);
    ref.invalidate(wishlistItemsProvider);
  }

  Future<bool> isInWishlist(String productName) async {
    final firestoreService = ref.read(firestoreServiceProvider);
    return await firestoreService.isInWishlist(productName);
  }
}
