class CommonResponse {
  late String message;
  late String status;

  CommonResponse({required this.message, required this.status});

  CommonResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "Something went wrong";
    status = json['status'] ?? "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
