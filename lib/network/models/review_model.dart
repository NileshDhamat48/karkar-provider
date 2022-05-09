import 'package:karkar_provider_app/network/models/user_data.dart';

class ReviewModel {
  int? id;
  String? rating;
  String? review;
  int? providerId;
  int? userId;
  String? createdAt;
  int? isOnline;
  UserData? user;

  ReviewModel(
      {this.id,
      this.rating,
      this.review,
      this.providerId,
      this.userId,
      this.createdAt,
      this.isOnline,
      this.user});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    review = json['review'];
    providerId = json['provider_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    isOnline = json['is_online'];
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rating'] = rating;
    data['review'] = review;
    data['provider_id'] = providerId;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
