import 'package:admin_toutn/core/model/sitedata.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../core/controller/claims_controller.dart';
import '../../core/model/chardata.dart';

class ChartSite extends StatefulWidget {
  @override
  ChartSiteState createState() => ChartSiteState();
}

class ChartSiteState extends State<ChartSite> {
  final claimsController = Get.put(ClaimsController());

  @override
  Widget build(BuildContext context) {
    final List<Color> color = <Color>[];
    color.add(Colors.blue[50]!);
    color.add(Colors.blue[200]!);
    color.add(Colors.blue);

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);

    final LinearGradient gradientColors =
        LinearGradient(colors: color, stops: stops);
    // TODO: implement build
    return GetBuilder<ClaimsController>(builder: (_) {
      return Container(
        height: MediaQuery.of(context).size.height / 2,
        //width: (MediaQuery.of(context).size.width / 3),
        padding: EdgeInsets.all(20),
        child: SfCircularChart(
            title: ChartTitle(
                text: "Réclamations par POI",
                alignment: ChartAlignment.center,
                textStyle: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                )),
            legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                overflowMode: LegendItemOverflowMode.wrap),
            series: <CircularSeries>[
              RadialBarSeries<SiteCharData, String>(
                  dataSource: claimsController.claimsSites,
                  xValueMapper: (SiteCharData data, _) => data.name,
                  yValueMapper: (SiteCharData data, _) => data.count,
                  dataLabelSettings: DataLabelSettings(isVisible: true))
            ]));});
  }
}
