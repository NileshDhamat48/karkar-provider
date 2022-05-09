import 'package:karkar_provider_app/network/models/booking_model.dart';

class BookingResponse {
  List<BookingModel>? data;
  late String message;
  late String status;

  BookingResponse({this.data, required this.message, required this.status});

  BookingResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BookingModel>[];
      json['data'].forEach((v) {
        data!.add(BookingModel.fromJson(v));
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
