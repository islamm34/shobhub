import 'package:hive_flutter/hive_flutter.dart';
import '../../models/product_model.dart';
import '../../models/cart_item_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static const String cartBoxName = 'cart_box';
  static const String wishlistBoxName = 'wishlist_box';
  static const String userBoxName = 'user_box';

  // ✅ لا تقم بتسجيل الـ Adapters هنا (مسجلة بالفعل في main.dart)
  Future<void> init() async {
    // فقط تأكد من أن الـ Boxes مفتوحة
    if (!Hive.isBoxOpen(cartBoxName)) {
      await Hive.openBox<CartItemModel>(cartBoxName);
    }
    if (!Hive.isBoxOpen(wishlistBoxName)) {
      await Hive.openBox(wishlistBoxName);
    }
    if (!Hive.isBoxOpen(userBoxName)) {
      await Hive.openBox(userBoxName);
    }
    print('✅ DatabaseService initialized');
  }

  Box<CartItemModel> get _cartBox => Hive.box<CartItemModel>(cartBoxName);
  Box get _wishlistBox => Hive.box(wishlistBoxName);
  Box get _userBox => Hive.box(userBoxName);

  // ==================== User Functions ====================

  Future<void> insertUser(String userId, String email, String displayName) async {
    await _userBox.put(userId, {
      'id': userId,
      'email': email,
      'displayName': displayName,
      'createdAt': DateTime.now().toIso8601String(),
    });
    print('✅ User inserted: $userId');
  }

  Future<void> deleteUser(String userId) async {
    await _userBox.delete(userId);
    // حذف سلة المستخدم
    final keysToDelete = <dynamic>[];
    for (var key in _cartBox.keys) {
      final item = _cartBox.get(key);
      if (item?.userId == userId) {
        keysToDelete.add(key);
      }
    }
    for (var key in keysToDelete) {
      await _cartBox.delete(key);
    }
    print('✅ User deleted: $userId');
  }

  Future<bool> userExists(String userId) async {
    return _userBox.containsKey(userId);
  }

  // ==================== Cart Functions ====================

  Future<void> addToCart({
    required int productId,
    required String title,
    required String thumbnail,
    required double price,
    required double discountPercentage,
    required int quantity,
    required String userId,
  }) async {
    // البحث عن المنتج في السلة
    String? existingKey;
    CartItemModel? existingItem;

    for (var key in _cartBox.keys) {
      final item = _cartBox.get(key);
      if (item != null && item.productId == productId && item.userId == userId) {
        existingKey = key.toString();
        existingItem = item;
        break;
      }
    }

    if (existingItem != null && existingKey != null) {
      // تحديث الكمية
      final newQuantity = existingItem.quantity + quantity;
      final updatedItem = CartItemModel(
        id: existingItem.id,
        productId: productId,
        title: title,
        thumbnail: thumbnail,
        price: price,
        discountPercentage: discountPercentage,
        quantity: newQuantity,
        addedDate: existingItem.addedDate,
        userId: userId,
      );
      await _cartBox.put(existingKey, updatedItem);
      print('✅ Updated cart quantity for product $productId to $newQuantity');
    } else {
      // إضافة منتج جديد
      final newItem = CartItemModel(
        id: DateTime.now().millisecondsSinceEpoch,
        productId: productId,
        title: title,
        thumbnail: thumbnail,
        price: price,
        discountPercentage: discountPercentage,
        quantity: quantity,
        addedDate: DateTime.now(),
        userId: userId,
      );
      await _cartBox.add(newItem);
      print('✅ Added product $productId to cart');
    }
  }

  Future<List<CartItemModel>> getCart(String userId) async {
    final List<CartItemModel> items = [];
    for (var item in _cartBox.values) {
      if (item.userId == userId) {
        items.add(item);
      }
    }
    items.sort((a, b) => b.addedDate.compareTo(a.addedDate));
    print('📦 Cart items for user $userId: ${items.length}');
    return items;
  }

  Future<void> updateCartQuantity(int productId, int quantity, String userId) async {
    String? keyToUpdate;
    CartItemModel? itemToUpdate;

    for (var key in _cartBox.keys) {
      final item = _cartBox.get(key);
      if (item != null && item.productId == productId && item.userId == userId) {
        keyToUpdate = key.toString();
        itemToUpdate = item;
        break;
      }
    }

    if (itemToUpdate != null && keyToUpdate != null) {
      if (quantity <= 0) {
        await _cartBox.delete(keyToUpdate);
        print('✅ Removed product $productId from cart');
      } else {
        final updatedItem = CartItemModel(
          id: itemToUpdate.id,
          productId: productId,
          title: itemToUpdate.title,
          thumbnail: itemToUpdate.thumbnail,
          price: itemToUpdate.price,
          discountPercentage: itemToUpdate.discountPercentage,
          quantity: quantity,
          addedDate: itemToUpdate.addedDate,
          userId: userId,
        );
        await _cartBox.put(keyToUpdate, updatedItem);
        print('✅ Updated cart quantity for product $productId to $quantity');
      }
    }
  }

  Future<void> removeFromCart(int productId, String userId) async {
    String? keyToDelete;
    for (var key in _cartBox.keys) {
      final item = _cartBox.get(key);
      if (item != null && item.productId == productId && item.userId == userId) {
        keyToDelete = key.toString();
        break;
      }
    }
    if (keyToDelete != null) {
      await _cartBox.delete(keyToDelete);
      print('✅ Removed product $productId from cart');
    }
  }

  Future<void> clearCart(String userId) async {
    final keysToDelete = <dynamic>[];
    for (var key in _cartBox.keys) {
      final item = _cartBox.get(key);
      if (item != null && item.userId == userId) {
        keysToDelete.add(key);
      }
    }
    for (var key in keysToDelete) {
      await _cartBox.delete(key);
    }
    print('✅ Cleared cart for user $userId');
  }

  // ==================== Wishlist Functions ====================

  Future<void> addToWishlist({
    required int productId,
    required String title,
    required String thumbnail,
    required double price,
    required double discountPercentage,
    required double rating,
    required int reviewCount,
    required String userId,
  }) async {
    // التحقق إذا كان المنتج موجود بالفعل
    for (var key in _wishlistBox.keys) {
      final item = _wishlistBox.get(key);
      if (item != null && item['productId'] == productId && item['userId'] == userId) {
        print('✅ Product already in wishlist');
        return;
      }
    }

    await _wishlistBox.add({
      'productId': productId,
      'title': title,
      'thumbnail': thumbnail,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'reviewCount': reviewCount,
      'addedDate': DateTime.now().toIso8601String(),
      'userId': userId,
    });
    print('✅ Added product $productId to wishlist');
  }

  Future<List<Map<String, dynamic>>> getWishlist(String userId) async {
    final List<Map<String, dynamic>> items = [];
    for (var item in _wishlistBox.values) {
      if (item['userId'] == userId) {
        items.add(Map<String, dynamic>.from(item));
      }
    }
    items.sort((a, b) => b['addedDate'].compareTo(a['addedDate']));
    return items;
  }

  Future<void> removeFromWishlist(int productId, String userId) async {
    dynamic keyToDelete;
    for (var key in _wishlistBox.keys) {
      final item = _wishlistBox.get(key);
      if (item != null && item['productId'] == productId && item['userId'] == userId) {
        keyToDelete = key;
        break;
      }
    }
    if (keyToDelete != null) {
      await _wishlistBox.delete(keyToDelete);
      print('✅ Removed product $productId from wishlist');
    }
  }

  Future<void> clearWishlist(String userId) async {
    final keysToDelete = <dynamic>[];
    for (var key in _wishlistBox.keys) {
      final item = _wishlistBox.get(key);
      if (item != null && item['userId'] == userId) {
        keysToDelete.add(key);
      }
    }
    for (var key in keysToDelete) {
      await _wishlistBox.delete(key);
    }
    print('✅ Cleared wishlist for user $userId');
  }

  Future<bool> isInWishlist(int productId, String userId) async {
    for (var item in _wishlistBox.values) {
      if (item != null && item['productId'] == productId && item['userId'] == userId) {
        return true;
      }
    }
    return false;
  }
}