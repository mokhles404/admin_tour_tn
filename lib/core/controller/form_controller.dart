// @dart=2.9

import 'dart:io';
import 'package:admin_toutn/core/model/event.dart' as ev;
import 'package:admin_toutn/core/model/imaa_patri.dart';
import 'package:admin_toutn/core/model/notification.dart';
import 'package:admin_toutn/core/service/event_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';

class FormController extends GetxController {
  DocumentReference eventRef =
      FirebaseFirestore.instance.collection("events").doc();
  AdminService api = AdminService();
  dynamic uploadedFileURL;
  bool isloading = false;
  List<dynamic> eventsList = [], notificationList = [];
  String query="";

  @override
  void onInit() {
    // Enable hybrid composition.
    super.onInit();
  }
  void setQuery(String sylla){
    query=sylla;
    update();
  }

  Future sendNotification(Notification notif) async {
    isloading = true;
    update();
    await api.sendNotification(notif);
    await FirebaseFirestore.instance.collection("notifications").add({
      "date": notif.date,
      "title": notif.title,
      "type": notif.type,
      "description": notif.description
    });
    await batchUpdate(notif);
    isloading = false;
    update();
  }

  Future removeEvent(dynamic id) async {
    eventsList.removeWhere((element) => element.id == id);
    await FirebaseFirestore.instance.collection("events").doc(id).delete();
    update();
  }

  Future<void> batchUpdate(Notification notif) {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    users.get().then(
          (value) => value.docs.forEach(
            (element) {
              var docRef = FirebaseFirestore.instance
                  .collection('users')
                  .doc(element.id);

              docRef.update({
                "notifications": FieldValue.arrayUnion([
                  {
                    "date": notif.date,
                    "title": notif.title,
                    "type": notif.type,
                    "read": false,
                    "description": notif.description
                  }
                ])
              });
            },
          ),
        );
    /*batch.update(users.doc(), {
      "notifications": FieldValue.arrayUnion([
        {
          "date": notif.date,
          "title": notif.title,
          "type": notif.type,
          "description": notif.description
        }
      ])
    });*/
  }

  Future getEvents() async {
    var temp = [];
    eventsList.clear();
    print(eventsList);
    var res = await FirebaseFirestore.instance.collection("events").get();
    print("res docs");
    print(res.docs);
    for (var e in res.docs) {
      temp.add(ev.Event.fromMap(e.data(), e.id));
    }
    eventsList = temp;
    print("event list");
    print(eventsList);
    return eventsList;
  }


  Future<void> saveImages(List<File> _images) async {
    /*  _images.forEach((image) async {
      String imageURL = await uploadFile(image);
      eventRef.update({"images": FieldValue.arrayUnion([imageURL])});
    });*/
  }

  Future<void> downloadURLExample() async {
    String downloadURL;
// Within your widgets:
// Image.network(downloadURL);
  }

  Future<dynamic> updateToFirebase(ev.Event event) async {
    isloading = true;
    update();
    print(event.id);
    var res = await FirebaseFirestore.instance
        .collection("events")
        .doc(event.id)
        .get();
    print(res.exists);
    await FirebaseFirestore.instance
        .collection("events")
        .doc(event.id)
        .set({
          "title_ar": event.title_ar,
          "title_fr": event.title_fr,
          "title_en": event.title_en,
          "desc_ar": event.desc_ar,
          "desc_fr": event.desc_fr,
          "desc_en": event.desc_en,
          "organization": event.organization,
          "location_ar": event.location_ar,
          "location_fr": event.location_fr,
          "location_en": event.location_en,
          "date_fin": event.date_fin,
          "time": event.time,
          "date_deb": event.date_deb,
          "image": event.image
        })
        .then((value) => print("doc added"))
        .catchError((error) => print("error" + error.toString()));
    isloading = false;
    update();
  }

  Future<dynamic> addToFirebase(ev.Event event) async {
    await eventRef.set({
      "title_ar": event.title_ar,
      "title_fr": event.title_fr,
      "title_en": event.title_en,
      "desc_ar": event.desc_ar,
      "desc_fr": event.desc_fr,
      "desc_en": event.desc_en,
      "organization": event.organization,
      "location_ar": event.location_ar,
      "location_fr": event.location_fr,
      "location_en": event.location_en,
      "date_fin": event.date_fin,
      "date_deb": event.date_deb,
      "time": event.time,
      "image": event.image,
    });
    isloading = false;
    update();
  }

  void setUploadUrl(url){
    uploadedFileURL = url;
    update();

  }
    Future<dynamic> uploadFile(File _image) async {
    isloading = true;
    update();
    var storageReference = FirebaseStorage.instance
        .ref()
        .child('events/${Path.basename(_image.path)}');
   var uploadTask= await storageReference
        .putFile(_image);
    await uploadTask.state;
    print('File Uploaded');
    await storageReference.getDownloadURL().then((fileURL) {
      uploadedFileURL = fileURL;
    });
    print("uploaded url");
    print(uploadedFileURL);
    update();
    return uploadedFileURL;
  }
}
