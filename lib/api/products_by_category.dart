import 'api_product.dart';

/// products : [{"id":121,"title":"iPhone 5s",...}]
/// total : 16
/// skip : 0
/// limit : 16

class ProductsByCategory {
  List<Products>? products;
  num? total;
  num? skip;
  num? limit;

  ProductsByCategory({
    this.products,
    this.total,
    this.skip,
    this.limit,
  });

  ProductsByCategory.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  ProductsByCategory copyWith({
    List<Products>? products,
    num? total,
    num? skip,
    num? limit,
  }) {
    return ProductsByCategory(
      products: products ?? this.products,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (products != null) {
      map['products'] = products!.map((v) => v.toJson()).toList();
    }
    map['total'] = total;
    map['skip'] = skip;
    map['limit'] = limit;
    return map;
  }
}

