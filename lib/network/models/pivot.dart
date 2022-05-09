class Pivot {
  int? appointmentId;
  int? categoryId;
  String? price;

  Pivot({this.appointmentId, this.categoryId, this.price});

  Pivot.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointment_id'];
    categoryId = json['category_id'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appointment_id'] = appointmentId;
    data['category_id'] = categoryId;
    data['price'] = price;
    return data;
  }
}
