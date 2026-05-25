import 'package:ecommerce/models/product_model.dart';

import 'category_model.dart';

/// استجابة API العامة
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {int? statusCode}) {
    return ApiResponse(
      success: true,
      data: data,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) {
    try {
      return ApiResponse.success(
        fromJsonT(json['data']),
        statusCode: json['statusCode'],
      );
    } catch (e) {
      return ApiResponse.error(
        json['message'] ?? 'An error occurred',
        statusCode: json['statusCode'],
      );
    }
  }
}

/// استجابة قائمة المنتجات
class ProductsResponse {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  ProductsResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  bool get hasMore => products.length < total;
  int get nextSkip => skip + limit;

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    return ProductsResponse(
      products: (json['products'] as List)
          .map((v) => ProductModel.fromJson(v))
          .toList(),
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((v) => v.toJson()).toList(),
      'total': total,
      'skip': skip,
      'limit': limit,
    };
  }
}

/// استجابة التصنيفات
class CategoriesResponse {
  final List<CategoryModel> categories;
  final int total;

  CategoriesResponse({
    required this.categories,
    required this.total,
  });

  factory CategoriesResponse.fromJson(List<dynamic> json) {
    return CategoriesResponse(
      categories: json.map((v) => CategoryModel.fromJson(v)).toList(),
      total: json.length,
    );
  }
}