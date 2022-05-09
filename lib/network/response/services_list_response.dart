import 'package:karkar_provider_app/network/models/services_model.dart';

class ServicesListResponse {
  List<ServicesModel>? data;
  late String message;
  late String status;

  ServicesListResponse(
      {this.data, required this.message, required this.status});

  ServicesListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ServicesModel>[];
      json['data'].forEach((v) {
        data!.add(ServicesModel.fromJson(v));
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
