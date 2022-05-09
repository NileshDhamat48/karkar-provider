class BeginCheckoutResponse {
  String? data;
  String? message;
  String? status;

  BeginCheckoutResponse({
    this.data,
    this.message,
    this.status,
  });

  BeginCheckoutResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = data;
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
