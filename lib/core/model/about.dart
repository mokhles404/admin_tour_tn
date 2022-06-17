class AboutUs {
  String? id;
  String? name_fr, name_en, name_ar;
  String? description_fr, description_en, description_ar;

AboutUs({
  this.id,
  this.description_fr,
  this.name_fr,
  this.description_en ,
  this.name_ar ,
  this.description_ar,
  this.name_en
});
  AboutUs.fromMap(Map<String, dynamic> map, id)
      : id = id,
        description_fr = map["description_fr"] ?? '',
        name_fr = map["name_fr"] ?? '',
        description_en = map["description_en"],
        name_ar = map["name_ar"] ?? '',
        description_ar = map["description_ar"],
        name_en = map["name_en"] ?? '';

  Map<String, dynamic> toJson() => {
        'description_fr': description_fr,
        'name_fr': name_fr,
        'name_ar': name_ar,
        'description_ar': description_ar,
        'name_en': name_en,
        'description_en': description_en
      };
}
