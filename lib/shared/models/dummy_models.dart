import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final String description;
  final String category;
  final List<String> images;
  final List<String> colors;
  final List<String> sizes;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.originalPrice = 0,
    this.rating = 0,
    this.reviewCount = 0,
    this.description = '',
    this.category = '',
    this.images = const [],
    this.colors = const [],
    this.sizes = const [],
  });
}

class Category {
  final String id;
  final String name;
  final String icon;
  final int productCount;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    this.productCount = 0,
  });
}

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
  });
}

class Order {
  final String id;
  final String orderNumber;
  final DateTime date;
  final double total;
  final String status;
  final List<Product> items;
  final int itemCount;

  Order({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.total,
    required this.status,
    this.items = const [],
    required this.itemCount,
  });
}

class CartItem {
  final Product product;
  int quantity;
  String selectedColor;
  String selectedSize;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedColor = '',
    this.selectedSize = '',
  });

  double get totalPrice => product.price * quantity;
}

class Address {
  final String id;
  final String label;
  final String name;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isDefault;

  Address({
    required this.id,
    required this.label,
    required this.name,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
  });
}

class Review {
  final String id;
  final String userName;
  final String userImage;
  final double rating;
  final String title;
  final String comment;
  final DateTime date;
  final int helpful;

  Review({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.title,
    required this.comment,
    required this.date,
    this.helpful = 0,
  });
}

class Notification {
  final String id;
  final String title;
  final String message;
  final IconData icon;  // Changed from String to IconData
  final DateTime date;
  final bool isRead;
  final String type;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.icon,  // Changed from String to IconData
    required this.date,
    this.isRead = false,
    this.type = 'order',
  });
}

// Dummy Data Provider
class DummyDataProvider {
  static List<Product> get products => [
    Product(
      id: '1',
      name: 'Premium Wireless Headphones',
      image: 'https://via.placeholder.com/200',
      price: 199.99,
      originalPrice: 299.99,
      rating: 4.8,
      reviewCount: 234,
      description: 'High-quality wireless headphones with noise cancellation',
      category: 'Electronics',
      images: ['https://via.placeholder.com/200'],
      colors: ['Black', 'White', 'Silver'],
      sizes: [],
    ),
    Product(
      id: '2',
      name: 'Designer Smart Watch',
      image: 'https://via.placeholder.com/200',
      price: 349.99,
      originalPrice: 449.99,
      rating: 4.6,
      reviewCount: 156,
      description: 'Premium smartwatch with fitness tracking',
      category: 'Electronics',
      images: ['https://via.placeholder.com/200'],
      colors: ['Gold', 'Silver', 'Space Gray'],
      sizes: [],
    ),
    Product(
      id: '3',
      name: 'Comfortable Joggers',
      image: 'https://via.placeholder.com/200',
      price: 79.99,
      originalPrice: 129.99,
      rating: 4.5,
      reviewCount: 89,
      description: 'Stylish and comfortable joggers for everyday wear',
      category: 'Fashion',
      images: ['https://via.placeholder.com/200'],
      colors: ['Black', 'Gray', 'Navy'],
      sizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
    ),
    Product(
      id: '4',
      name: 'Premium Running Shoes',
      image: 'https://via.placeholder.com/200',
      price: 159.99,
      originalPrice: 0,
      rating: 4.9,
      reviewCount: 412,
      description: 'Advanced running shoes with superior comfort',
      category: 'Footwear',
      images: ['https://via.placeholder.com/200'],
      colors: ['Black', 'White', 'Red'],
      sizes: ['6', '7', '8', '9', '10', '11', '12', '13'],
    ),
    Product(
      id: '5',
      name: 'Portable Power Bank',
      image: 'https://via.placeholder.com/200',
      price: 49.99,
      originalPrice: 79.99,
      rating: 4.7,
      reviewCount: 567,
      description: '30000mAh portable charger for all devices',
      category: 'Electronics',
      images: ['https://via.placeholder.com/200'],
      colors: ['Black', 'White', 'Blue'],
      sizes: [],
    ),
    Product(
      id: '6',
      name: 'Stainless Steel Water Bottle',
      image: 'https://via.placeholder.com/200',
      price: 34.99,
      originalPrice: 0,
      rating: 4.4,
      reviewCount: 123,
      description: 'Eco-friendly insulated water bottle',
      category: 'Accessories',
      images: ['https://via.placeholder.com/200'],
      colors: ['Silver', 'Gold', 'Rose Gold'],
      sizes: ['500ml', '750ml', '1L'],
    ),
  ];

  static List<Category> get categories => [
    Category(id: '1', name: 'Electronics', icon: 'icons_electronics', productCount: 245),
    Category(id: '2', name: 'Fashion', icon: 'icons_fashion', productCount: 512),
    Category(id: '3', name: 'Footwear', icon: 'icons_footwear', productCount: 234),
    Category(id: '4', name: 'Accessories', icon: 'icons_accessories', productCount: 189),
    Category(id: '5', name: 'Home', icon: 'icons_home', productCount: 356),
    Category(id: '6', name: 'Sports', icon: 'icons_sports', productCount: 278),
  ];

  static User get currentUser => User(
    id: '1',
    name: 'Sarah Anderson',
    email: 'sarah.anderson@email.com',
    phone: '+1 (555) 123-4567',
    profileImage: 'https://via.placeholder.com/100',
  );

  static List<Order> get orders => [
    Order(
      id: '1',
      orderNumber: '#ORD-2024-001',
      date: DateTime.now().subtract(const Duration(days: 5)),
      total: 459.97,
      status: 'Delivered',
      itemCount: 3,
      items: products.take(3).toList(),
    ),
    Order(
      id: '2',
      orderNumber: '#ORD-2024-002',
      date: DateTime.now().subtract(const Duration(days: 2)),
      total: 189.99,
      status: 'Shipped',
      itemCount: 1,
      items: [products[1]],
    ),
    Order(
      id: '3',
      orderNumber: '#ORD-2024-003',
      date: DateTime.now(),
      total: 34.99,
      status: 'Processing',
      itemCount: 1,
      items: [products[5]],
    ),
  ];

  static List<Review> get reviews => [
    Review(
      id: '1',
      userName: 'John Doe',
      userImage: 'https://via.placeholder.com/60',
      rating: 5,
      title: 'Excellent product!',
      comment: 'Great quality and fast delivery. Highly recommended!',
      date: DateTime.now().subtract(const Duration(days: 10)),
      helpful: 245,
    ),
    Review(
      id: '2',
      userName: 'Emma Wilson',
      userImage: 'https://via.placeholder.com/60',
      rating: 4,
      title: 'Good value for money',
      comment: 'Good product overall. Battery life is impressive.',
      date: DateTime.now().subtract(const Duration(days: 15)),
      helpful: 156,
    ),
    Review(
      id: '3',
      userName: 'Michael Brown',
      userImage: 'https://via.placeholder.com/60',
      rating: 5,
      title: 'Perfect!',
      comment: 'Exceeded my expectations. Worth every penny.',
      date: DateTime.now().subtract(const Duration(days: 20)),
      helpful: 89,
    ),
  ];

  static List<Address> get addresses => [
    Address(
      id: '1',
      label: 'Home',
      name: 'Sarah Anderson',
      phone: '+1 (555) 123-4567',
      street: '123 Oak Street, Apt 4B',
      city: 'New York',
      state: 'NY',
      zipCode: '10001',
      country: 'USA',
      isDefault: true,
    ),
    Address(
      id: '2',
      label: 'Work',
      name: 'Sarah Anderson',
      phone: '+1 (555) 123-4567',
      street: '456 Business Ave',
      city: 'New York',
      state: 'NY',
      zipCode: '10002',
      country: 'USA',
      isDefault: false,
    ),
  ];

  static List<Notification> get notifications => [
    Notification(
      id: '1',
      title: 'Order Delivered!',
      message: 'Your order #ORD-2024-001 has been delivered',
      icon: Icons.check_circle_rounded,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      type: 'order',
    ),
    Notification(
      id: '2',
      title: 'Special Offer',
      message: 'Get 30% off on premium items this weekend',
      icon: Icons.local_offer_rounded,
      date: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
      type: 'promotion',
    ),
  ];
}