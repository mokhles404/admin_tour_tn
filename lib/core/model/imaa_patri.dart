// @dart=2.9

class Immat {
  String id;
  String name_ar;
  String name_en;
  String name_fr;
  String source_ar, source_fr, source_en;
  String description_ar, description_en, description_fr;
  List<String> images;

  /*List<dynamic> categoryName = [];
  List<dynamic> categoryId = [];*/
  Immat(
      {this.id,
        this.name_ar,
        this.name_en,
        this.name_fr,

        this.source_ar,
        this.source_fr,
        this.source_en,
        this.description_ar,
        this.description_en,
        this.description_fr,
        this.images,
      });

  Immat.fromMap(Map<String, dynamic> map, dynamic id)
      : id = id,
        name_ar = map["name_ar"] ?? '',
        name_en = map["name_en"] ?? '',
        name_fr = map["name_fr"] ?? '',
        source_ar = map["source_ar"] ?? '',
        source_fr = map["source_fr"] ?? '',
        source_en = map["source_en"] ?? '',
        description_ar = map["description_ar"] ?? '',
        description_en = map["description_en"] ?? '',
        description_fr = map["description_fr"] ?? '',
        images = map["images"] != null ?map["images"].split(";"):[];
}
