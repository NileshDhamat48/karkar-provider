class TearmConditionModel {
  int? id;
  String? key;
  String? value;

  TearmConditionModel({this.id, this.key, this.value});

  TearmConditionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}
