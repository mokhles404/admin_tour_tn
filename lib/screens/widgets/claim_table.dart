import 'package:admin_toutn/core/model/Reclamation.dart';
import 'package:flutter/material.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:get/get.dart';

import '../../core/controller/claims_controller.dart';
import 'colors_cons.dart';

class RecentUsers extends StatelessWidget {
  RecentUsers({
    Key? key,
  }) : super(key: key);
  final claimsController = Get.put(ClaimsController());

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
            "Réclamations récentes",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SingleChildScrollView(
            //scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.6,
              child: DataTable(
                horizontalMargin: 0,
                columnSpacing: defaultPadding,
                columns: [
                  DataColumn(
                    label: Text("Titre"),
                  ),
                  DataColumn(
                    label: Text("Nom de POI"),
                  ),
                  DataColumn(
                    label: Text("E-mail"),
                  ),
                  DataColumn(
                    label: Text("Date"),
                  ),
                  DataColumn(
                    label: Text("Opération"),
                  ),
                ],
                rows: List.generate(
                  claimsController.allclaims.length,
                  (index) => recentUserDataRow(
                      claimsController.allclaims[index], context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentUserDataRow(Reclamation claim, BuildContext context) {
  return DataRow(
    cells: [
      DataCell(
        Container(
            child: Row(
          children: [
            Container(
              height: 25,
              width: 25,
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.red),
              child: Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 15,
              ),
            ),
            Container(
              child: Text(
                claim.title!,
                softWrap: true,
                maxLines: 3,
                //overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        )),
      ),
      DataCell(Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(.2),
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(5.0) //
                ),
          ),
          child: Text(claim.siteName!))),
      DataCell(Text(claim.email!)),
      DataCell(Text(claim.date!)),
      DataCell(
        TextButton(
          child: Text("Vue", style: TextStyle(color: Colors.green)),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                      title: Container(
                        //height: 100,
                        child: Column(
                          children: [
                            Icon(Icons.info_outline,
                                size: 36, color: Colors.greenAccent),
                            SizedBox(height: 20),
                            Text(claim.title),
                            SizedBox(height: 20),
                            Text(claim.siteName),
                          ],
                        ),
                      ),
                      content: Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 4,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Text("Date: " + claim.date),
                            SizedBox(
                              height: 16,
                            ),
                            Text(claim.description),
                            SizedBox(
                              height: 16,
                            ),
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
                                label: Text("Ferme")),
                          ],
                        ),
                      ));
                });
          },
          // Delete
        ),
      ),
    ],
  );
}
