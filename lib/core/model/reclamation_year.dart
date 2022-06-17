import 'package:admin_toutn/core/model/reclamation_month.dart';

class ReclamationYear{
  String id;
  String year;
  List<ReclamationMonth> recs;
  ReclamationYear.fromMap(Map<String, dynamic> map)
      : id = map["_id"],
        recs = map["monthArray"] ??[],
        year = map["year"] ?? '';

  Map<String, dynamic> toJson() => {
    'monthArray': recs,
    'year': year
  };
}