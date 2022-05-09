import 'package:karkar_provider_app/network/models/offer_plan_model.dart';

class OfferPlanResponse {
  List<OfferPlan>? data;
  String? message;
  String? status;

  OfferPlanResponse({
    this.data,
    this.message,
    this.status,
  });

  OfferPlanResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <OfferPlan>[];
      json['data'].forEach((v) {
        data!.add(OfferPlan.fromJson(v));
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
