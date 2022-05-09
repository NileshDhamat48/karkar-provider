class UserLocation {
  String? address;
  double? lat;
  double? lng;

  UserLocation({
    this.address,
    this.lat,
    this.lng,
  });

  UserLocation.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    lat = json['latitude'];
    lng = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['latitude'] = lat;
    data['longitude'] = lng;

    return data;
  }
}
