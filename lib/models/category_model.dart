/// نموذج بيانات التصنيف
class CategoryModel {
  final String? slug;
  final String? name;
  final String? url;
  final String? icon;
  final int? productCount;

  CategoryModel({
    this.slug,
    this.name,
    this.url,
    this.icon,
    this.productCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      slug: json['slug'],
      name: json['name'],
      url: json['url'],
      icon: json['icon'],
      productCount: json['productCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'url': url,
      'icon': icon,
      'productCount': productCount,
    };
  }
}