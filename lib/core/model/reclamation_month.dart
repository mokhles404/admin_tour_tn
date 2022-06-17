import 'package:admin_toutn/core/model/reclamation_date.dart';

class ReclamationMonth{
  String id;
  String month;
  List<Reclamationdate> recs;
  ReclamationMonth.fromMap(Map<String, dynamic> map)
      : id = map["_id"],
        recs = map["dateArray"] ??[],
        month = map["month"] ?? '';

  Map<String, dynamic> toJson() => {
    'dateArray': recs,
    'month': month
  };
}