import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../core/controller/claims_controller.dart';
import '../../core/model/chardata.dart';

class ChartMonth extends StatefulWidget {
  @override
  ChartMonthState createState() => ChartMonthState();
}

class ChartMonthState extends State<ChartMonth> {
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
        width: MediaQuery.of(context).size.width / 1.5,
        child: SfCartesianChart(
            borderWidth: 4,
            title: ChartTitle(
                text: "Réclamations mensuelles chaque mois en ${claimsController.year}",
                alignment: ChartAlignment.center,
                textStyle: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                )),
            zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                zoomMode: ZoomMode.xy,
                enablePanning: true,
                enableSelectionZooming: true,
                selectionRectBorderColor: Colors.red,
                selectionRectBorderWidth: 1,
                selectionRectColor: Colors.grey),
            tooltipBehavior: TooltipBehavior(enable: true),
            primaryYAxis: NumericAxis(),
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries<CharData, String>>[
              SplineAreaSeries<CharData, String>(
                  name: "Réclamations chaque mois Stat",
                  borderWidth: 4,
                  borderColor: Color(0xff0b91ff).withOpacity(0.5),
                  dataSource: claimsController.claimsMonths,
                  xValueMapper: (CharData data, _) => data.month,
                  yValueMapper: (CharData data, _) => data.count,
                  gradient: gradientColors)
            ]));});
  }
}
