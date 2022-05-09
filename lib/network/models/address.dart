class Address {
  int? id;
  String? title;
  String? address;
  String? longitude;
  String? latitude;
  int? userId;
  String? createdAt;
  String? updatedAt;
  Address({
    this.id,
    this.title,
    this.address,
    this.longitude,
    this.latitude,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['address'] = address;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
