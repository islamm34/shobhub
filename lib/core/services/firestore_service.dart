import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/product_model.dart';
import '../../models/wishlist_item.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ الحصول على معرف المستخدم الحالي
  String? get currentUserId => _auth.currentUser?.uid;

  // ✅ التحقق من وجود مستخدم مسجل الدخول
  bool get isUserLoggedIn => currentUserId != null;

  // ✅ مرجع وثيقة المستخدم
  DocumentReference get _userDoc {
    if (currentUserId == null) {
      throw Exception('User not logged in. Please login first.');
    }
    return _firestore.collection('users').doc(currentUserId);
  }

  // ✅ تهيئة وثيقة المستخدم عند تسجيل الدخول
  Future<void> initUserDocument() async {
    if (!isUserLoggedIn) {
      print('⚠️ No user logged in, skipping initUserDocument');
      return;
    }

    try {
      final doc = await _userDoc.get();
      if (!doc.exists) {
        await _userDoc.set({
          'userId': currentUserId,
          'email': _auth.currentUser?.email ?? '',
          'displayName': _auth.currentUser?.displayName ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'wishlistNames': [],  // ✅ تخزين أسماء المنتجات
          'cart': [],
        });
        print('✅ User document created for: ${_auth.currentUser?.email}');
      } else {
        print('✅ User document already exists for: ${_auth.currentUser?.email}');
      }
    } catch (e) {
      print('❌ Error initializing user document: $e');
    }
  }

  // ==================== Wishlist Functions (بالاسم) ====================

  // ✅ الحصول على قائمة Wishlist (كـ List of Strings)
  Future<List<String>> getWishlistNames() async {
    if (!isUserLoggedIn) {
      print('⚠️ No user logged in, returning empty wishlist');
      return [];
    }

    try {
      final doc = await _userDoc.get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final wishlistNames = data['wishlistNames'] as List<dynamic>?;
        return wishlistNames?.map((e) => e.toString()).toList() ?? [];
      }
    } catch (e) {
      print('Error getting wishlist: $e');
    }
    return [];
  }

  // ✅ Stream للاستماع للتغييرات في Wishlist (يعيد List<String>)
  Stream<List<String>> getWishlistStream() {
    if (!isUserLoggedIn) {
      return Stream.value([]);
    }

    return _userDoc.snapshots().map((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final wishlistNames = data['wishlistNames'] as List<dynamic>?;
        return wishlistNames?.map((e) => e.toString()).toList() ?? [];
      }
      return [];
    });
  }

  // ✅ إضافة منتج إلى Wishlist بالاسم
  Future<void> addToWishlist(String productName) async {
    if (!isUserLoggedIn) {
      print('⚠️ Cannot add to wishlist: User not logged in');
      throw Exception('Please login to add to wishlist');
    }

    await _userDoc.update({
      'wishlistNames': FieldValue.arrayUnion([productName])
    });
    print('✅ Added product "$productName" to wishlist for user: ${_auth.currentUser?.email}');
  }

  // ✅ إزالة منتج من Wishlist بالاسم
  Future<void> removeFromWishlist(String productName) async {
    if (!isUserLoggedIn) {
      print('⚠️ Cannot remove from wishlist: User not logged in');
      return;
    }

    await _userDoc.update({
      'wishlistNames': FieldValue.arrayRemove([productName])
    });
    print('✅ Removed product "$productName" from wishlist for user: ${_auth.currentUser?.email}');
  }

  // ✅ مسح Wishlist بالكامل
  Future<void> clearWishlist() async {
    if (!isUserLoggedIn) return;

    await _userDoc.update({'wishlistNames': []});
    print('✅ Cleared wishlist for user: ${_auth.currentUser?.email}');
  }

  // ✅ التحقق إذا كان المنتج في Wishlist
  Future<bool> isInWishlist(String productName) async {
    if (!isUserLoggedIn) return false;

    final wishlistNames = await getWishlistNames();
    return wishlistNames.contains(productName);
  }

  // ==================== Cart Functions ====================

  // ✅ الحصول على قائمة Cart
  Future<List<Map<String, dynamic>>> getCart() async {
    if (!isUserLoggedIn) return [];

    try {
      final doc = await _userDoc.get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final cart = data['cart'] as List<dynamic>?;
        return cart?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [];
      }
    } catch (e) {
      print('Error getting cart: $e');
    }
    return [];
  }

  // ✅ Stream للاستماع للتغييرات في Cart
  Stream<List<Map<String, dynamic>>> getCartStream() {
    if (!isUserLoggedIn) {
      return Stream.value([]);
    }

    return _userDoc.snapshots().map((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final cart = data['cart'] as List<dynamic>?;
        return cart?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [];
      }
      return [];
    });
  }

  // ✅ إضافة منتج إلى Cart
  Future<void> addToCart({
    required int productId,
    required String title,
    required String thumbnail,
    required double price,
    required double discountPercentage,
    int quantity = 1,
  }) async {
    if (!isUserLoggedIn) {
      throw Exception('Please login to add to cart');
    }

    final currentCart = await getCart();
    final existingIndex = currentCart.indexWhere((item) => item['productId'] == productId);

    if (existingIndex != -1) {
      final newQuantity = (currentCart[existingIndex]['quantity'] as int) + quantity;
      currentCart[existingIndex]['quantity'] = newQuantity;
      await _userDoc.update({'cart': currentCart});
    } else {
      final newItem = {
        'productId': productId,
        'title': title,
        'thumbnail': thumbnail,
        'price': price,
        'discountPercentage': discountPercentage,
        'quantity': quantity,
        'addedDate': DateTime.now().toIso8601String(),
      };
      await _userDoc.update({
        'cart': FieldValue.arrayUnion([newItem])
      });
    }
    print('✅ Added product $productId to cart for user: ${_auth.currentUser?.email}');
  }

  // ✅ تحديث كمية منتج في Cart
  Future<void> updateCartQuantity(int productId, int quantity) async {
    if (!isUserLoggedIn) return;

    final currentCart = await getCart();
    final index = currentCart.indexWhere((item) => item['productId'] == productId);

    if (index != -1) {
      if (quantity <= 0) {
        currentCart.removeAt(index);
      } else {
        currentCart[index]['quantity'] = quantity;
      }
      await _userDoc.update({'cart': currentCart});
    }
  }

  // ✅ إزالة منتج من Cart
  Future<void> removeFromCart(int productId) async {
    if (!isUserLoggedIn) return;

    final currentCart = await getCart();
    currentCart.removeWhere((item) => item['productId'] == productId);
    await _userDoc.update({'cart': currentCart});
  }

  // ✅ مسح Cart بالكامل
  Future<void> clearCart() async {
    if (!isUserLoggedIn) return;

    await _userDoc.update({'cart': []});
  }
}