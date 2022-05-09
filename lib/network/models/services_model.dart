import 'package:karkar_provider_app/network/models/services_pivot.dart';
import 'package:karkar_provider_app/network/models/sub_services.dart';

class ServicesModel {
  int? id;
  String? title;
  String? imageUrl;
  String? secondaryImageUrl;
  ServicesPivot? pivot;
  List<SubServices>? subServices;

  ServicesModel(
      {this.id,
      this.title,
      this.imageUrl,
      this.secondaryImageUrl,
      this.pivot,
      this.subServices});

  ServicesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imageUrl = json['image_url'];
    secondaryImageUrl = json['secondary_image_url'];
    pivot =
        json['pivot'] != null ? ServicesPivot.fromJson(json['pivot']) : null;
    if (json['sub_services'] != null) {
      subServices = <SubServices>[];
      json['sub_services'].forEach((v) {
        subServices!.add(SubServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image_url'] = imageUrl;
    data['secondary_image_url'] = secondaryImageUrl;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    if (subServices != null) {
      data['sub_services'] = subServices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
