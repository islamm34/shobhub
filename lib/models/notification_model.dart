import 'package:flutter/material.dart';

/// نموذج بيانات الإشعار
class NotificationModel {
  final String? id;
  final String? title;
  final String? message;
  final IconData? icon;
  final DateTime? date;
  final bool? isRead;
  final String? type;

  NotificationModel({
    this.id,
    this.title,
    this.message,
    this.icon,
    this.date,
    this.isRead,
    this.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      icon: _getIconFromString(json['icon']),
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      isRead: json['isRead'],
      type: json['type'],
    );
  }

  static IconData? _getIconFromString(String? iconName) {
    switch (iconName) {
      case 'order':
        return Icons.shopping_bag_rounded;
      case 'promotion':
        return Icons.local_offer_rounded;
      case 'payment':
        return Icons.payment_rounded;
      case 'shipping':
        return Icons.local_shipping_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'date': date?.toIso8601String(),
      'isRead': isRead,
      'type': type,
    };
  }
}