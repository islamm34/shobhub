import 'product_model.dart';

/// عنصر في السلة
class CartItemModel {
  final ProductModel product;
  int quantity;
  String selectedColor;
  String selectedSize;

  CartItemModel({
    required this.product,
    this.quantity = 1,
    this.selectedColor = '',
    this.selectedSize = '',
  });

  double get totalPrice => (product.price ?? 0) * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
      selectedColor: json['selectedColor'],
      selectedSize: json['selectedSize'],
    );
  }
}

/// نموذج السلة الكامل
class CartModel {
  List<CartItemModel> items;

  CartModel({this.items = const []});

  int get itemCount => items.length;

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  double get shipping => subtotal > 500 ? 0 : 50;

  double get tax => subtotal * 0.18;

  double get total => subtotal + shipping + tax;

  void addItem(CartItemModel item) {
    final existingIndex = items.indexWhere(
          (i) => i.product.id == item.product.id &&
          i.selectedColor == item.selectedColor &&
          i.selectedSize == item.selectedSize,
    );

    if (existingIndex != -1) {
      items[existingIndex].quantity += item.quantity;
    } else {
      items.add(item);
    }
  }

  void removeItem(int index) {
    items.removeAt(index);
  }

  void updateQuantity(int index, int quantity) {
    if (quantity > 0) {
      items[index].quantity = quantity;
    }
  }

  void clear() {
    items.clear();
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((v) => v.toJson()).toList(),
    };
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items: (json['items'] as List)
          .map((v) => CartItemModel.fromJson(v))
          .toList(),
    );
  }
}