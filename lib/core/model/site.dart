// @dart=2.9

import 'monument.dart';

class Site {
  String id;
  String name_ar;
  String name_en;
  String name_fr;
  String ville;
  String ville_ar;
  String gouvernorat;
  String gouvernorat_ar;
  String source_ar, source_fr, source_en;
  String lat;
  String long;
  String type;
  String description_ar, description_en, description_fr;
  List<String> epoque;
  String region;
  List<String> image360;
  String horaire_hiver;
  String horaire_ete;
  String horaire_ramadan;
  List<String> jour_ferm;
  String heur_ferm;
  bool ar_exist;
  bool ticket_group;
  bool pm_ens;
  List<String> tel;
  String frais_etranger;
  String frais_resident;
  bool panoramaPhoto;
  List<String> images;
  List<String> commodites;
  bool patrimoine;
  List<dynamic> monument = [];

  /*List<dynamic> categoryName = [];
  List<dynamic> categoryId = [];*/
  Site(
      {this.id,
        this.name_ar,
        this.name_en,
        this.name_fr,
        this.ville,
        this.ville_ar,
        this.source_ar,
        this.source_fr,
        this.source_en,
        this.ticket_group,
        this.pm_ens,
        this.tel,
        this.frais_etranger,
        this.frais_resident,
        this.gouvernorat,
        this.gouvernorat_ar,
        this.lat,
        this.long,
        this.type,
        this.description_ar,
        this.description_en,
        this.description_fr,
        this.epoque,
        this.region,
        this.image360,
        this.horaire_hiver,
        this.horaire_ete,
        this.horaire_ramadan,
        this.jour_ferm,
        this.heur_ferm,
        this.ar_exist,
        this.panoramaPhoto,
        this.patrimoine,
        this.images,
        this.commodites,
        this.monument});

  Site.fromMap(Map<String, dynamic> map)
      : id = map["_id"],
        name_ar = map["name_ar"] ?? '',
        name_en = map["name_en"] ?? '',
        name_fr = map["name_fr"] ?? '',
        source_ar = map["source_ar"] ?? '',
        source_fr = map["source_fr"] ?? '',
        source_en = map["source_en"] ?? '',
        ticket_group = map["ticket_group"] ?? false,
        pm_ens = map["pm_ens"] ?? false,
        tel = map["tel"] != null ? map["tel"].split(";") : [],
        frais_etranger = map["frais_etranger"] ?? '',
        frais_resident = map["frais_resident"] ?? '',
        gouvernorat = map["gouvernorat"] ?? '',
        gouvernorat_ar = map["gouvernorat_ar"] ?? '',
        ville = map["ville"] ?? '',
        ville_ar = map["ville_ar"] ?? '',
        lat = map["lat"],
        long = map["long"] ?? '',
        type = map["type"] ?? '',
        description_ar = map["description_ar"] ?? '',
        description_en = map["description_en"] ?? '',
        description_fr = map["description_fr"] ?? '',
        epoque = map['epoque'] != null ? map["epoque"].split(";") : [],
        region = map["region"] ?? '',
        image360 = map['image360'] != null ? map["image360"].split(";") : [],
        horaire_hiver = map["horaire_hiver"] ?? '',
        horaire_ete = map["horaire_ete"] ?? '',
        horaire_ramadan = map["horaire_ramadan"] ?? '',
        jour_ferm = map["jour_ferm"] != null ?  map["jour_ferm"].split(";") : [],
        heur_ferm = map["heur_ferm"] ?? '',
        ar_exist = map["ar_exist"] ?? false,
        panoramaPhoto = map["panoramaPhoto"] ?? false,
        patrimoine = map["patrimoine"] ?? false,
        monument = map["monument"].length != 0
            ? map["monument"].map((e) => Monument.fromMap(e)).toList()
            : [],
        images = map["images"] != null ?map["images"].split(";"):[],
        commodites =
        map["commodite"] != null ? map["commodite"].split(";") : [];

  Map<String, dynamic> toJson() => {
    'name_ar': name_ar,
    'name_fr': name_fr,
    'name_en': name_en,
    'source_ar': source_ar,
    'source_fr': source_fr,
    'source_en': source_en,
    "ticket_group":ticket_group,
    "patrimoine":patrimoine,
    'description_ar': description_ar,
    'description_fr': description_fr,
    'description_en': description_en,
    'ville_ar': ville_ar,
    'ville': ville,
    'gouvernorat_ar': gouvernorat_ar,
    'gouvernorat': gouvernorat,
    'frais_etranger': frais_etranger,
    'frais_resident': frais_resident,
    'horaire_hiver': horaire_hiver,
    'horaire_ete': horaire_ete,
    'horaire_ramadan': horaire_ramadan,
    'lat': lat,
    'long': long,
    'images': images.join(";"),
    'image360': image360.join(";"),
    'commodite': commodites.join(";"),
    'jour_ferm': jour_ferm.join(";"),
    'heur_ferm': heur_ferm
  };
/* categoryName = map['categories'] != null
            ? map['categories'].map((category) {
          return category["name"];
        }).toList()
            : null,
        categoryId = map['categories'] != null
            ? map['categories'].map((category) {
          return category["id"];
        }).toList()
            : null;*/
}
