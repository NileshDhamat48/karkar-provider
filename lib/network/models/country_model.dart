
class CountryModel {
  int? id;
  String? iso;
  String? name;
  String? nicename;
  String? iso3;
  int? numcode;
  int? phonecode;

  CountryModel(
      {this.id,
      this.iso,
      this.name,
      this.nicename,
      this.iso3,
      this.numcode,
      this.phonecode});

  CountryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iso = json['iso'];
    name = json['name'];
    nicename = json['nicename'];
    iso3 = json['iso3'];
    numcode = json['numcode'];
    phonecode = json['phonecode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['iso'] = iso;
    data['name'] = name;
    data['nicename'] = nicename;
    data['iso3'] = iso3;
    data['numcode'] = numcode;
    data['phonecode'] = phonecode;
    return data;
  }
}