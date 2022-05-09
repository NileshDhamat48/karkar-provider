import 'package:karkar_provider_app/network/models/terms_condition_model.dart';

class TermsConditionResponse {
  List<TearmConditionModel>? data;
  late String? message;
  late String? status;

  TermsConditionResponse({this.data, this.message, this.status});

  TermsConditionResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TearmConditionModel>[];
      json['data'].forEach((v) {
        data!.add(TearmConditionModel.fromJson(v));
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
