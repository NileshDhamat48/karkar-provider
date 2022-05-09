import 'package:karkar_provider_app/network/models/country_model.dart';

class CountryListResponse {
  List<CountryModel>? data;
  late String message;
  late String status;

  CountryListResponse({this.data, required this.message, required this.status});

  CountryListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CountryModel>[];
      json['data'].forEach((v) {
        data!.add(CountryModel.fromJson(v));
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
