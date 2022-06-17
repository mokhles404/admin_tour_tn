class Reclamation{
  String id;
  String idsite;
 String description;
  String title;
  String email;
  String nomUser;
  String date;
  String siteName;
  String count;
  Reclamation.fromMap(Map<String, dynamic> map)
      : id = map["_id"],
        idsite = map["idsite"] ?? '',
        description = map["description"] ?? '',
        title = map["title"] ?? '',
        email = map["email"],
        nomUser = map["nomUser"] ?? '',
        siteName = map["siteName"] ?? '',
        count = map["count"] ?? '',
        date = map["date"] ?? '';

  Map<String, dynamic> toJson() => {
    'idsite': idsite,
    'description': description,
    'title': title,
    'email': email,
    'nomUser': nomUser,
    'siteName': siteName,
    'count': count,
    'date': date
  };
}