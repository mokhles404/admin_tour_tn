import 'package:admin_toutn/core/model/Reclamation.dart';

class Reclamationdate{
  String id;
  String date;
  List<Reclamation> recs;
  Reclamationdate.fromMap(Map<String, dynamic> map)
      : id = map["_id"],
        recs = map["recs"] ??[],
        date = map["date"] ?? '';

  Map<String, dynamic> toJson() => {
    'recs': recs,
    'date': date
  };
}