import 'api_product.dart';

/// products : [{"id":104,"title":"Apple iPhone Charger",...}]
/// total : 8
/// skip : 0
/// limit : 8

class ApiSearchResponsed {
  List<Products>? products;
  num? total;
  num? skip;
  num? limit;

  ApiSearchResponsed({
    this.products,
    this.total,
    this.skip,
    this.limit,
  });

  ApiSearchResponsed.fromJson(Map<String, dynamic> json) {
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

  ApiSearchResponsed copyWith({
    List<Products>? products,
    num? total,
    num? skip,
    num? limit,
  }) {
    return ApiSearchResponsed(
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

// إعادة استخدام Products, Meta, Reviews, Dimensions من الملف السابق