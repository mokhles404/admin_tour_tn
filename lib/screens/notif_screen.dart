import 'package:admin_toutn/core/controller/claims_controller.dart';
import 'package:admin_toutn/screens/widgets/colors_cons.dart';
import 'package:admin_toutn/screens/widgets/notif_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/controller/notif_controller.dart';
import 'notification_form.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  final notifsController = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    print("I AM GETTING CLAIMS");
    // TODO: implement build
    return  Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xffc16161),
          child: Icon(
            Icons.notifications_active,
            color: Colors.white,
          ),
          onPressed: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NotifScreen()));
          },
        ),
        backgroundColor: Color(0xfff9f9f9),
        appBar: AppBar(
          backgroundColor: Color(0xfff9f9f9),
          elevation: 0.0,
          centerTitle: true,
          actions: [

          ],
          title: Text(
            'Liste des notifications',
            style: TextStyle(color: Color(0xffc16161)),
          ),
        ),
        body: SafeArea(
        child: SingleChildScrollView(
            //padding: EdgeInsets.all(defaultPadding),
            child: Container(
                padding: EdgeInsets.all(defaultPadding),
                child: Column(children: [NotificationTable()])))));
  }
}
