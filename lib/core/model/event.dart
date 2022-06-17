// @dart=2.9

class Event {
  String id;
  String title_ar,
      title_en,
      title_fr,
      desc_ar,
      desc_en,
      desc_fr,
      organization,
      date_fin,
      date_deb,
      image,
      location_ar,
      location_fr,
      location_en,
      time;

  Event(
      {this.id,
      this.title_ar,
      this.title_en,
      this.title_fr,
      this.location_ar,
      this.location_fr,
      this.location_en,
      this.organization,
      this.desc_ar,
      this.desc_en,
      this.desc_fr,
      this.date_fin,
      this.date_deb,
      this.time,
      this.image});

  Event.fromMap(Map<String, dynamic> map, dynamic id)
      : id = id,
        title_fr = map["title_fr"]??'',
        title_ar = map["title_ar"]??'',
        title_en = map["title_en"]??'',
        desc_ar = map["desc_ar"]??'',
        desc_fr = map["desc_fr"]??'',
        desc_en = map["desc_en"]??'',
        location_ar = map["location_ar"]??'',
        location_fr = map["location_fr"]??'',
        location_en = map["location_en"]??'',
        organization = map["organization"]??'',
        date_deb = map["date_deb"]??'',
        date_fin = map["date_fin"]??'',
        time = map["time"]??'',
        image = map["image"]??'';
}
