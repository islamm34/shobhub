/// slug : "beauty"
/// name : "Beauty"
/// url : "https://dummyjson.com/products/category/beauty"

class ApiCategories {
  String? slug;
  String? name;
  String? url;

  ApiCategories({
    this.slug,
    this.name,
    this.url,
  });

  ApiCategories.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    name = json['name'];
    url = json['url'];
  }

  ApiCategories copyWith({
    String? slug,
    String? name,
    String? url,
  }) {
    return ApiCategories(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['slug'] = slug;
    map['name'] = name;
    map['url'] = url;
    return map;
  }
}