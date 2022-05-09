import 'package:karkar_provider_app/network/models/booking_model.dart';

class BookingDetailsResponse {
  BookingModel? data;
  late String message;
  late String status;

  BookingDetailsResponse(
      {this.data, required this.message, required this.status});

  BookingDetailsResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? BookingModel.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
