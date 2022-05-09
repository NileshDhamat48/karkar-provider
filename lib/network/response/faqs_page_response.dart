import 'package:karkar_provider_app/network/models/faqs_model.dart';

class FaqsResponce {
  List<FaqsData>? data;
  late String message;
  late String status;

  FaqsResponce({this.data, required this.message, required this.status});

  FaqsResponce.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <FaqsData>[];
      json['data'].forEach((v) {
        data!.add(FaqsData.fromJson(v));
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
