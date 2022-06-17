import 'package:admin_toutn/core/model/about.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AboutUsController extends GetxController {
  CollectionReference db = FirebaseFirestore.instance.collection("about");
  AboutUs? object;
  bool? isloading=false;
  @override
  void onInit() {
    // TODO: implement onInit
    getAbout();
    super.onInit();
  }

  getAbout() async {
    var res = await db.doc("DyFFzLGsGaYyAcAPfXvF").get();
    Map<String, dynamic>? temp = res.data() as Map<String, dynamic>?;
    print("getting about");
    print(temp);
    object = AboutUs.fromMap(temp!, res.id);
    update();
    return object;
  }

  updateAbout(Map<String,dynamic>data) async {
    isloading=true;
    update();

    await db.doc("DyFFzLGsGaYyAcAPfXvF").update(data);
    object = AboutUs.fromMap(data!, "DyFFzLGsGaYyAcAPfXvF");
    isloading=false;
    update();
    return object;
  }
}
