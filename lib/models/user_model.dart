/// نموذج بيانات المستخدم
class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? profileImage;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profileImage,
  });

  String get firstName => name?.split(' ').first ?? '';
  String get lastName => name?.split(' ').last ?? '';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
    };
  }
}