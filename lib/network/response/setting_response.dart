import 'package:karkar_provider_app/network/models/setting_model.dart';

class SettingResponse {
  List<SettingModel>? data;
  late String message;
  late String status;

  SettingResponse({this.data, required this.message, required this.status});

  SettingResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SettingModel>[];
      json['data'].forEach((v) {
        data!.add(SettingModel.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
