import 'package:karkar_provider_app/network/models/brand.dart';

class Vehicle {
  int? id;
  String? carNumber;
  String? imageUrl;
  String? model;
  int? brandId;
  int? userId;
  String? description;
  String? insuranceDeadline;
  String? couponDeadline;
  String? overhaulDeadline;
  String? taxDeadline;
  Brand? brand;

  Vehicle(
      {this.id,
      this.carNumber,
      this.imageUrl,
      this.model,
      this.brandId,
      this.userId,
      this.description,
      this.insuranceDeadline,
      this.couponDeadline,
      this.overhaulDeadline,
      this.taxDeadline,
      this.brand});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    carNumber = json['car_number'];
    imageUrl = json['image_url'];
    model = json['model'];
    brandId = json['brand_id'];
    userId = json['user_id'];
    description = json['description'];
    insuranceDeadline = json['insurance_deadline'];
    couponDeadline = json['coupon_deadline'];
    overhaulDeadline = json['overhaul_deadline'];
    taxDeadline = json['tax_deadline'];
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['car_number'] = carNumber;
    data['image_url'] = imageUrl;
    data['model'] = model;
    data['brand_id'] = brandId;
    data['user_id'] = userId;
    data['description'] = description;
    data['insurance_deadline'] = insuranceDeadline;
    data['coupon_deadline'] = couponDeadline;
    data['overhaul_deadline'] = overhaulDeadline;
    data['tax_deadline'] = taxDeadline;
    if (brand != null) {
      data['brand'] = brand!.toJson();
    }
    return data;
  }
}
