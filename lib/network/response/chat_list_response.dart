import 'package:karkar_provider_app/network/models/user_data.dart';

class ChatListResponse {
  int? totalCount;
  List<UserData>? data;
  String? nextPage;
  String? message;
  String? status;

  ChatListResponse({this.totalCount, this.data, this.nextPage, this.message, this.status});

  ChatListResponse.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(UserData.fromJson(v));
      });
    }
    nextPage = json['next_page'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_count'] = totalCount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['next_page'] = nextPage;
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
