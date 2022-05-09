import 'package:karkar_provider_app/network/models/user_data.dart';

class UserResponse {
  String? token;
  UserData? data;
  late String message;
  late String status;

  UserResponse(
      {this.token, this.data, required this.message, required this.status});

  UserResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
