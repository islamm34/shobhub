/// نموذج بيانات العنوان
class AddressModel {
  final String? id;
  final String? label;
  final String? name;
  final String? phone;
  final String? street;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final bool? isDefault;

  AddressModel({
    this.id,
    this.label,
    this.name,
    this.phone,
    this.street,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.isDefault,
  });

  String get fullAddress => '$street, $city, $state $zipCode, $country';

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      label: json['label'],
      name: json['name'],
      phone: json['phone'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      country: json['country'],
      isDefault: json['isDefault'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'name': name,
      'phone': phone,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'isDefault': isDefault,
    };
  }
}