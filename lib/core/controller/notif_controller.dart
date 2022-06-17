// @dart=2.9

import 'package:admin_toutn/core/model/notification.dart';
import 'package:get/get.dart';
import '../service/event_service.dart';

class NotificationsController extends GetxController {
  AdminService api = AdminService();
  List<Notification> notifs = [];

  bool isLoading = false;
  @override
  void onInit() {
    // TODO: implement onInit
    getAllNotif();
    super.onInit();
  }

  Future resendNotif(notif){
    isLoading=true;
    api.sendNotification(notif);
    isLoading=false;
  }
  Future getAllNotif() async {
    notifs = await api.getAllNotif();
    return notifs;
  }
}
