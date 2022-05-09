class ServicesPivot {
  int? providerId;
  int? categoryId;
  String? price;
  bool? isSelected;

  ServicesPivot({
    this.providerId,
    this.categoryId,
    this.price,
    this.isSelected = false,
  });

  ServicesPivot.fromJson(Map<String, dynamic> json) {
    providerId = json['provider_id'];
    categoryId = json['category_id'];
    price = json['price'];
    isSelected = json['isselected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['provider_id'] = providerId;
    data['category_id'] = categoryId;
    data['price'] = price;
    data['isselected'] = isSelected;

    return data;
  }
}
