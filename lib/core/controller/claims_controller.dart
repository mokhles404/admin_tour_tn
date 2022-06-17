import 'package:admin_toutn/core/model/Reclamation.dart';
import 'package:admin_toutn/core/model/chardata.dart';
import 'package:admin_toutn/core/model/sitedata.dart';
import 'package:get/get.dart';

import '../service/event_service.dart';

class ClaimsController extends GetxController {
  AdminService api = AdminService();
  List<Reclamation> allclaims = [];
  List<SiteCharData> claimsSites = [];
  List<CharData> claimsMonths = [];
  String year="2022";
bool isLoading=false;
  @override
  void onInit() {
    // TODO: implement onInit
    getClaims();
    getClaimsMonths(year);

    super.onInit();
  }

  Future getClaims() async {
    allclaims= await api.getAllClaims();
    getClaimsSites();
    update();

  }
  Future getClaimsMonths(year) async {
   claimsMonths= await api.getClaimsPermonth(year);
   update();

   return claimsMonths;
  }


  Future sendFeedback(
      {String? name, String? email, String? message, String? title}) async {
    isLoading = true;
    update();
    await api.sendEmail(
        name: name, email: email, message: message, title: title);
    isLoading = false;
    update();
  }
  void getClaimsSites() {
    for (var e in allclaims) {
      if (claimsSites.isNotEmpty) {
        var index =
            claimsSites.indexWhere((element) => element.name == e.siteName);
        if (index == -1) {
          print("not found");
          print("-1");
          print(e.siteName);
          claimsSites.add(SiteCharData(name: e.siteName, count: 1));
        } else {
          print("found");
          print("$index");
          print(e.siteName);
          claimsSites[index] = SiteCharData(
              name: claimsSites[index].name,
              count: (claimsSites[index].count + 1));
        }
      } else {
        print("empty list sites");
        claimsSites.add(SiteCharData(name: e.siteName, count: 1));
        print(claimsSites.length);
      }
    }
    update();
  }
}
