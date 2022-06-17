import 'package:admin_toutn/core/controller/claims_controller.dart';
import 'package:admin_toutn/screens/widgets/chart_tile.dart';
import 'package:admin_toutn/screens/widgets/claim_site_chart.dart';
import 'package:admin_toutn/screens/widgets/claim_table.dart';
import 'package:admin_toutn/screens/widgets/claims_month_chart.dart';
import 'package:admin_toutn/screens/widgets/colors_cons.dart';
import 'package:admin_toutn/screens/widgets/quick_contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notification_form.dart';

class Claims extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ClaimsState();
}

class ClaimsState extends State<Claims> {
  final claimsController = Get.put(ClaimsController());

  @override
  Widget build(BuildContext context) {
    print("I AM GETTING CLAIMS");
    // TODO: implement build
    return GetBuilder<ClaimsController>(builder: (_) {
      return Scaffold(
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
          actions: [],
          title: Text(
            'Liste des réclamations',
            style: TextStyle(color: Color(0xffc16161)),
          ),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            child: ListView(shrinkWrap: true, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /* ChartCardTile(
                cardColor: Color(0xFF7560ED),
                cardTitle: 'chart 1',
                subText: 'Year 2022',
                icon: Icons.pie_chart,
                typeText: 'Claims per month/2022',
              ),*/
                  Container(
                      margin: EdgeInsets.only(left: 2,top: 20,bottom: 20),
                    child:  Material(
                      elevation: 10,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                      child: ChartMonth())),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(child:Container(
                    margin: EdgeInsets.only(right: 5,top: 20,bottom: 20),
                      child: Material(
                          elevation: 10,
                          shadowColor: Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                          child: ChartSite()))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /* ChartCardTile(
                cardColor: Color(0xFF7560ED),
                cardTitle: 'chart 1',
                subText: 'Year 2022',
                icon: Icons.pie_chart,
                typeText: 'Claims per month/2022',
              ),*/
                  QuickContact(),
                  SizedBox(
                    width: 20,
                  ),
                  Material(
                      elevation: 10,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          width: MediaQuery.of(context).size.width / 1.5,
                          // padding: EdgeInsets.all(defaultPadding),
                          child: RecentUsers())),
                ],
              ),
              SizedBox(
                height: 100,
              )
            ])));});
  }
}
