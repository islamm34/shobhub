import 'package:flutter/material.dart';

import 'product_model.dart';

/// نموذج بيانات الطلب
class OrderModel {
  final String? id;
  final String? orderNumber;
  final DateTime? date;
  final double? total;
  final String? status;
  final List<ProductModel>? items;
  final int? itemCount;

  OrderModel({
    this.id,
    this.orderNumber,
    this.date,
    this.total,
    this.status,
    this.items,
    this.itemCount,
  });

  // لون حالة الطلب
  Color get statusColor {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'Shipped':
        return Colors.orange;
      case 'Processing':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderNumber: json['orderNumber'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      total: json['total']?.toDouble(),
      status: json['status'],
      items: json['items'] != null
          ? (json['items'] as List).map((v) => ProductModel.fromJson(v)).toList()
          : null,
      itemCount: json['itemCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'date': date?.toIso8601String(),
      'total': total,
      'status': status,
      'items': items?.map((v) => v.toJson()).toList(),
      'itemCount': itemCount,
    };
  }
}