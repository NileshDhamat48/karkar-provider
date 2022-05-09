class AroundModel {
  int? id;
  String? title;
  bool? isCheckedApi;
  PivotAround? pivot;
  AroundModel({this.id, this.title, this.isCheckedApi = false, this.pivot});

  AroundModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    isCheckedApi = json['ischeck'];
    pivot = json['pivot'] != null ? PivotAround.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['ischeck'] = isCheckedApi;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class PivotAround {
  int? userId;
  int? aroundId;

  PivotAround({this.userId, this.aroundId});

  PivotAround.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    aroundId = json['around_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['around_id'] = aroundId;
    return data;
  }
}
