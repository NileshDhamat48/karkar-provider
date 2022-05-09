import 'package:karkar_provider_app/network/models/review_model.dart';

class ReviewResponse {
  dynamic avgRating;
  String? totalCount;
  List<ReviewModel>? data;
  String? nextPage;
  String? message;
  String? status;

  ReviewResponse({this.avgRating, this.totalCount, this.data, this.nextPage, this.message, this.status});

  ReviewResponse.fromJson(Map<String, dynamic> json) {
    avgRating = json['avg_rating'];
    totalCount = json['total_count'];
    if (json['data'] != null) {
      data = <ReviewModel>[];
      json['data'].forEach((v) {
        data!.add(ReviewModel.fromJson(v));
      });
    }
    nextPage = json['next_page'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['avg_rating'] = avgRating;
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
