import 'package:karkar_provider_app/network/models/user_data.dart';

class ResOffer {
  List<OfferModel>? data;
  String? nextPage;
  String? message;
  String? status;

  ResOffer({this.data, this.nextPage, this.message, this.status});

  ResOffer.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <OfferModel>[];
      json['data'].forEach((v) {
        data!.add(OfferModel.fromJson(v));
      });
    }
    nextPage = json['next_page'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['next_page'] = nextPage;
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class OfferModel {
  int? id;
  int? userId;
  String? description;
  String? startDate;
  String? endDate;
  String? price;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;
  bool? isActive;
  UserData? user;

  OfferModel(
      {this.id,
      this.userId,
      this.description,
      this.startDate,
      this.endDate,
      this.price,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt,
      this.isActive,
      this.user});

  OfferModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    price = json['price'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isActive = json['is_active'];
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['description'] = description;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['price'] = price;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_active'] = isActive;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Role {
  int? userId;
  int? roleId;

  Role({this.userId, this.roleId});

  Role.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    roleId = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['role_id'] = roleId;
    return data;
  }
}
