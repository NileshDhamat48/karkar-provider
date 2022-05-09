class OfferPlan {
  late int id;
  String? title;
  String? price;
  int? duration;

  OfferPlan({
    required this.id,
    this.title,
    this.price,
    this.duration,
  });

  OfferPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['duration'] = duration;

    return data;
  }
}
