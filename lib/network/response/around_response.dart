import 'package:karkar_provider_app/network/models/around.dart';

class AroundResponse {
  List<AroundModel>? data;
  late String message;
  late String status;

  AroundResponse({this.data, required this.message, required this.status});

  AroundResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AroundModel>[];
      json['data'].forEach((v) {
        data!.add(AroundModel.fromJson(v));
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
