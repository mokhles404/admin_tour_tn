// @dart=2.9

class Notification{
  String id;
  String title;
  String description;
  String type;
  String date;
  Notification({
    this.title,
    this.description,
    this.type,
    this.date
});
  Notification.fromMap(Map<String, dynamic> map,id)
      : id = id,
        description = map["description"] ?? '',
        title = map["title"] ?? '',
        type = map["type"],
        date = map["date"] ?? '';


}