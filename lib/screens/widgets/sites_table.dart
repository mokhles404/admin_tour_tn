import 'package:admin_toutn/core/model/Reclamation.dart';
import 'package:flutter/material.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:get/get.dart';

import '../../core/controller/api_controller.dart';
import '../../core/model/site.dart';
import '../add_one_site.dart';
import 'colors_cons.dart';

class SitesList extends StatelessWidget {
  final places;
  SitesList({
    Key? key, this.places,
  }) : super(key: key);
  final placecontroller = Get.put(PlacesController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Liste des POI",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SingleChildScrollView(
            //scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: double.infinity,
              child: DataTable(
                horizontalMargin: 0,
                columnSpacing: defaultPadding,
                columns: [
                  DataColumn(
                    label: Text("Nom de POI"),
                  ),
                  DataColumn(
                    label: Text("Statut"),
                  ),
                  DataColumn(
                    label: Text("Type"),
                  ),
                  DataColumn(
                    label: Text("ère"),
                  ),
                  DataColumn(
                    label: Text("Opération"),
                  ),
                ],
                rows: List.generate(
                  places.length,
                  (index) => recentUserDataRow(
                      places[index], context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentUserDataRow(Site site, BuildContext context) {
  final placecontroller = Get.put(PlacesController());

  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            TextAvatar(
              size: 35,
              backgroundColor: Colors.white,
              textColor: Colors.white,
              fontSize: 14,
              upperCase: true,
              numberLetters: 1,
              shape: Shape.Rectangle,
              text: site.name_en!,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                site.name_en!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      DataCell(Container(
          width: 100,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: site.jour_ferm.isNotEmpty
                ? (site.jour_ferm.any(
                        (element) => element.toLowerCase() == "maintenance"))
                    ? Colors.red.withOpacity(.2)
                    : Colors.green.withOpacity(.2)
                : Colors.green.withOpacity(.2),
            border: Border.all(
                color: site.jour_ferm.isNotEmpty
                    ? (site.jour_ferm.any((element) =>
                            element.toLowerCase() == "maintenance"))
                        ? Colors.red
                        : Colors.green
                    : Colors.green),
            borderRadius: BorderRadius.all(Radius.circular(5.0) //
                ),
          ),
          child: Text(
            site.jour_ferm.isNotEmpty
                ? (site.jour_ferm.any(
                        (element) => element.toLowerCase() == "maintenance"))
                    ? "Maintenance"
                    : "Ouvert"
                : "Ouvert",
            textAlign: TextAlign.center,
            /*site.jour_ferm.isNotEmpty
              ? (site.jour_ferm.any((element) => element.toLowerCase() ==
              "maintenance")
              ? "in maintenance"
              : "open")
              : "open"*/
          ))),
      DataCell(Text(
          site.type.isNotEmpty ? site.type.split(";").toList()[0]! : "type")),
      DataCell(Text(site.epoque.isNotEmpty ? site.epoque[0] : "epoque")),
      DataCell(
        Row(
          children: [
            TextButton(
              child: Text('Vue', style: TextStyle(color: greenColor)),
              onPressed: () {

                placecontroller.setDetail(site);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddOneSite(
                          update: true,
                        )));
              },
            ),
            SizedBox(
              width: 6,
            ),
            TextButton(
              child: Text("Supprimer", style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                          title: Center(
                            child: Column(
                              children: [
                                Icon(Icons.warning_outlined,
                                    size: 36, color: Colors.red),
                                SizedBox(height: 20),
                                Text("Confirmer la suppression"),
                              ],
                            ),
                          ),
                          content: Container(
                            color: Colors.white,
                            height: 70,
                            child: Column(
                              children: [
                                Text(
                                    "Êtes-vous sûr de vouloir supprimer '${site.name_en}'?"),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                        icon: Icon(
                                          Icons.close,
                                          size: 14,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.grey),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        label: Text("Annuler")),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    ElevatedButton.icon(
                                        icon: Icon(
                                          Icons.delete,
                                          size: 14,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.red),
                                        onPressed: () async {
                                          var id= placecontroller.places.indexOf(site);
                                          print(id);
                                         await placecontroller.deleteSite(site.id);
                                          placecontroller.setplaces(id);
                                          Navigator.pop(context);
                                        },
                                        label: Text("Supprimer"))
                                  ],
                                )
                              ],
                            ),
                          ));
                    });
              },
              // Delete
            ),
          ],
        ),
      ),
    ],
  );
}
