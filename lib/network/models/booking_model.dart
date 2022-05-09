import 'package:karkar_provider_app/network/models/address.dart';
import 'package:karkar_provider_app/network/models/services.dart';
import 'package:karkar_provider_app/network/models/user_data.dart';
import 'package:karkar_provider_app/network/models/vehicle.dart';

class BookingModel {
  int? id;
  int? providerId;
  int? userId;
  String? type;
  int? addressId;
  String? date;
  String? timeFrom;
  String? status;
  int? categoryId;
  String? notes;
  String? paymentStatus;
  String? paymentMethod;
  int? carId;
  int? isPickupDropIncluded;
  String? totalPrice;
  String? createdAt;
  String? updatedAt;
  Address? address;
  String? description;

  Provider? provider;
  UserData? user;
  Vehicle? vehicle;
  List<Services>? services;

  BookingModel(
      {this.id,
      this.providerId,
      this.userId,
      this.description,
      this.type,
      this.addressId,
      this.date,
      this.timeFrom,
      this.status,
      this.categoryId,
      this.notes,
      this.paymentStatus,
      this.paymentMethod,
      this.carId,
      this.isPickupDropIncluded,
      this.totalPrice,
      this.createdAt,
      this.updatedAt,
      this.address,
      this.provider,
      this.user,
      this.vehicle,
      this.services});

  BookingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    userId = json['user_id'];
    type = json['type'];
    addressId = json['address_id'];
    date = json['date'];
    timeFrom = json['time_from'];
    status = json['status'];
    categoryId = json['category_id'];
    notes = json['notes'];
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    description = json['description'];

    carId = json['car_id'];
    isPickupDropIncluded = json['is_pickup_drop_included'];
    totalPrice = json['total_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    provider =
        json['provider'] != null ? Provider.fromJson(json['provider']) : null;
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
    vehicle =
        json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    provider =
        json['provider'] != null ? Provider.fromJson(json['provider']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['provider_id'] = providerId;
    data['user_id'] = userId;
    data['type'] = type;
    data['address_id'] = addressId;
    data['date'] = date;
    data['time_from'] = timeFrom;
    data['status'] = status;
    data['category_id'] = categoryId;
    data['notes'] = notes;
    data['payment_status'] = paymentStatus;
    data['payment_method'] = paymentMethod;
    data['car_id'] = carId;
    data['is_pickup_drop_included'] = isPickupDropIncluded;
    data['total_price'] = totalPrice;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['description'] = description;

    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class Provider {
  int? id;
  String? name;
  String? email;
  String? mobileNumber;
  String? imageUrl;
  String? gender;
  String? latitude;
  String? longitude;
  String? address;
  String? about;
  String? openingTime;
  String? closingTime;
  bool? isProfileCompleted;
  String? distance;
  String? type;
  String? avgRating;
  bool? isFavorite;

  Provider(
      {this.id,
      this.name,
      this.email,
      this.mobileNumber,
      this.imageUrl,
      this.gender,
      this.latitude,
      this.longitude,
      this.address,
      this.about,
      this.openingTime,
      this.closingTime,
      this.isProfileCompleted,
      this.distance,
      this.type,
      this.avgRating,
      this.isFavorite});

  Provider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    imageUrl = json['image_url'];
    gender = json['gender'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    about = json['about'];
    openingTime = json['opening_time'];
    closingTime = json['closing_time'];
    isProfileCompleted = json['is_profile_completed'];
    distance = json['distance'];
    type = json['type'];
    avgRating = json['avg_rating'];
    isFavorite = json['is_favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['mobile_number'] = mobileNumber;
    data['image_url'] = imageUrl;
    data['gender'] = gender;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['about'] = about;
    data['opening_time'] = openingTime;
    data['closing_time'] = closingTime;
    data['is_profile_completed'] = isProfileCompleted;
    data['distance'] = distance;
    data['type'] = type;
    data['avg_rating'] = avgRating;
    data['is_favorite'] = isFavorite;
    return data;
  }
}
