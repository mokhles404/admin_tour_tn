import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../model/imaa_patri.dart';
import '../service/event_service.dart';

class ImmatController extends GetxController {
  dynamic uploadedFileURL;
  List<dynamic> ImmaList = [];
  bool isloading = false;
  AdminService api = AdminService();
  String queryImma = "";
  List<dynamic> imagesUpdate = [];
  Immat? detail;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void setImagesUpdate(data) {
    imagesUpdate = data;
    update();
  }

  void setDetail(Immat imma) {
    detail = imma;
    setImagesUpdate(detail!.images);
    update();
  }

  void setQueryImma(String sylla) {
    queryImma = sylla;
    update();
  }

  Future getImmaPatri() async {
    var temp = [];
    ImmaList.clear();
    print(ImmaList);
    temp = await api.getImma();
    ImmaList = temp;
    print("Immaterial list");
    print(ImmaList);
    return ImmaList;
  }

  Future removeEvent(dynamic id) async {
    ImmaList.removeWhere((element) => element.id == id);
    await FirebaseFirestore.instance.collection("events").doc(id).delete();
    update();
  }

  Future<dynamic> updateToFirebase(Immat immat) async {
    isloading = true;
    update();
    print(immat.id);
    var res = await FirebaseFirestore.instance
        .collection("immaterial")
        .doc(immat.id)
        .get();
    print(res.exists);
    await FirebaseFirestore.instance
        .collection("immaterial")
        .doc(immat.id)
        .set({
          "name_ar": immat.name_ar,
          "name_fr": immat.name_fr,
          "name_en": immat.name_en,
          "description_ar": immat.description_ar,
          "description_fr": immat.description_ar,
          "description_en": immat.description_en,
          "source_ar": immat.source_ar,
          "source_fr": immat.source_fr,
          "source_en": immat.source_en,
          "images": immat.images.join(";")
        })
        .then((value) => print("doc added"))
        .catchError((error) => print("error" + error.toString()));
    isloading = false;
    update();
  }

  Future<dynamic> addToFirebase(Immat immat) async {
    isloading=true;
    update();
    await FirebaseFirestore.instance.collection("immaterial").add({
      "name_ar": immat.name_ar,
      "name_fr": immat.name_fr,
      "name_en": immat.name_en,
      "description_ar": immat.description_ar,
      "desccription_fr": immat.description_ar,
      "description_en": immat.description_en,
      "source_ar": immat.source_ar,
      "source_fr": immat.source_fr,
      "source_en": immat.source_en,
      "images": immat.images.join(";")
    }).then((value) => print("Immaterial poi Added"))
        .catchError((error) => print("Failed to add immaterial poi: $error"));
    isloading = false;
    update();
  }

  void setUploadUrl(url) {
    uploadedFileURL = url;
    update();
  }
}
