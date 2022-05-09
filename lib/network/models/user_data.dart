import 'package:karkar_provider_app/network/models/chat_user_pivot.dart';

class UserData {
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
  bool? isOpenOnMon;
  bool? isOpenOnTue;
  bool? isOpenOnWeb;
  bool? isOpenOnThu;
  bool? isOpenOnFri;
  bool? isOpenOnSat;
  bool? isOpenOnSun;
  Pivot? pivot;

  UserData({
    this.id,
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
    this.isOpenOnMon,
    this.isOpenOnTue,
    this.isOpenOnWeb,
    this.isOpenOnThu,
    this.isOpenOnFri,
    this.isOpenOnSat,
    this.isOpenOnSun,
    this.avgRating,
    this.pivot,
  });

  UserData.fromJson(Map<String, dynamic> json) {
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
    isOpenOnMon = json['is_open_on_mon'];
    isOpenOnTue = json['is_open_on_tue'];
    isOpenOnWeb = json['is_open_on_web'];
    isOpenOnThu = json['is_open_on_thu'];
    isOpenOnFri = json['is_open_on_fri'];
    isOpenOnSat = json['is_open_on_sat'];
    isOpenOnSun = json['is_open_on_sun'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
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
    data['is_open_on_mon'] = isOpenOnMon;
    data['is_open_on_tue'] = isOpenOnTue;
    data['is_open_on_web'] = isOpenOnWeb;
    data['is_open_on_thu'] = isOpenOnThu;
    data['is_open_on_fri'] = isOpenOnFri;
    data['is_open_on_sat'] = isOpenOnSat;
    data['is_open_on_sun'] = isOpenOnSun;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}
