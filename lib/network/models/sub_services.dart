import 'package:karkar_provider_app/network/models/services_pivot.dart';

class SubServices {
  int? id;
  String? title;
  String? imageUrl;
  String? secondaryImageUrl;
  int? parentId;
  ServicesPivot? pivot;

  SubServices({
    this.id,
    this.title,
    this.imageUrl,
    this.secondaryImageUrl,
    this.parentId,
    this.pivot,
  });

  SubServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imageUrl = json['image_url'];
    secondaryImageUrl = json['secondary_image_url'];
    parentId = json['parent_id'];

    pivot =
        json['pivot'] != null ? ServicesPivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image_url'] = imageUrl;
    data['secondary_image_url'] = secondaryImageUrl;

    data['parent_id'] = parentId;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }

    return data;
  }
}
