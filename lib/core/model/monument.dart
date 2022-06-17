// @dart=2.9

class Monument {
  String id;
  String name_en;
  String name_fr;
  String name_ar;
  String lat;
  String long;
  String type;
  String image;

  Monument(
      {this.id ,
      this.name_en ,
      this.name_ar ,
      this.name_fr ,
      this.lat ,
      this.long ,
      this.type ,
      this.image });

  Monument.fromMap(Map<String, dynamic> map)
      : id = map["_id"],
        name_ar = map["name_ar"] ?? '',
        name_en = map["name_en"] ?? '',
        name_fr = map["name_fr"] ?? '',
        lat = map["lat"],
        long = map["long"] ?? '',
        type = map["type"] ?? '',
        image = map["image"] ?? '';

  Map<String, dynamic> toJson() => {
        'name_ar': name_ar,
        'name_fr': name_fr,
        'name_en': name_en,
        'lat': lat,
        'long': long,
        'image': image,
        'type': type
      };
}
