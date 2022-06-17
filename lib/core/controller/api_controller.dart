// @dart=2.9

import 'package:admin_toutn/core/model/site.dart';
import 'package:admin_toutn/core/service/api_service.dart';
import 'package:get/get.dart';

class PlacesController extends GetxController {
  List<Site> places = [];
  ApiService api = ApiService();
  List<dynamic> imagesUpdate = [];
  List<dynamic> images360Update = [];
  List<dynamic> monumentUpdate = [];
  List<dynamic> commUpdate = [];
  List<dynamic> typesUpdate = [];
  List<dynamic> epoUpdate = [];
  List<dynamic> joursUpdate = [];
  String region="NO";
  bool isloading = false;
  bool maintenanceUpdate = false;
  bool toilette = false;
  bool park = false;
  bool boutique = false;
  bool cafeteria = false;
  bool ascenseurs = false;
  Site detail;
  String query = "";

  @override
  void onInit() {
    // TODO: implement onInit
    getSitesByFilter("/");
    super.onInit();
  }

  void setQuery(String sylla) {
    query = sylla;
    update();
  }

  void setRegion(String reg) {
    region = reg;
    update();
  }

  void setDetail(Site site) {
    detail = site;
    imagesUpdate = detail.images;
    images360Update = detail.image360;
    monumentUpdate = detail.monument;
    commUpdate = detail.commodites;
    typesUpdate=detail.type.split(";");
    epoUpdate=detail.epoque;
    region=detail.region;
    joursUpdate = detail.jour_ferm;
    if (detail.jour_ferm
        .any((element) => element.toLowerCase() == "maintenance")) {
      setMaintenanceUpdate(true);
    } else {
      setMaintenanceUpdate(false);
    }
    if (commUpdate.contains("Toilettes")) {
      setToilette(true);
    }
    if (commUpdate.contains("Assenceurs")) {
      setAsc(true);
    }
    if (commUpdate.contains("Boutique")) {
      setBoutique(true);
    }
    if (commUpdate.contains("Cafétéria")) {
      setCafeteria(true);
    }
    if (commUpdate.contains("Parking")) {
      setPark(true);
    }
    update();
  }

  setToilette(bool val) {
    toilette = val;
    update();
  }

  setPark(bool val) {
    park = val;
    update();
  }

  setBoutique(bool val) {
    boutique = val;
    update();
  }

  setCafeteria(bool val) {
    cafeteria = val;
    update();
  }

  setAsc(bool val) {
    ascenseurs = val;
    update();
  }

  void setMaintenanceUpdate(bool maintenance) {
    maintenanceUpdate = maintenance;
    update();
  }

  void setImagesUpdate(List<dynamic> images) {
    imagesUpdate = images;
    update();
  }

  void setJoursUpdate(List<dynamic> jours) {
    joursUpdate = jours;
    update();
  }

  void setImages360Update(List<dynamic> images) {
    images360Update = images;
    update();
  }

  void setMonumentUpdate(List<dynamic> monument) {
    monumentUpdate = monument;
    update();
  }

  void setCommUpdate(List<dynamic> comms) {
    commUpdate = comms;
    update();
  }
  void setTypesUpdate(List<dynamic> types) {
    typesUpdate = types;
    update();
  }
  void setEpoUpdate(List<dynamic> epo) {
    epoUpdate = epo;
    update();
  }

  void setplaces(index) {
    update();
    places.removeAt(index);
    update();
  }

  Future updateSite(data, id) async {
    isloading = true;
    update();
    var res = await api.updateSite(data, id);
    print(res);
    isloading = false;
    update();
    return res;
  }

  Future postSite(data) async {
    isloading = true;
    update();
    var res = await api.createSite(data);
    print(res);
    isloading = false;
    update();
    return res;
  }

  Future deleteSite(id) async {
    isloading = true;
    update();
    var res = await api.deleteSite(id);
    print(res);
    isloading = false;
    update();
    return res;
  }

  Future getSitesByFilter(String query) async {
    places = await api.getSitesPerFilter(query);
    print("I finished getting sites");
    return places;
  }
}
