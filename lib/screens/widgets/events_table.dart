import 'package:admin_toutn/core/controller/form_controller.dart';
import 'package:admin_toutn/core/model/Reclamation.dart';
import 'package:admin_toutn/core/model/event.dart';
import 'package:flutter/material.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:get/get.dart';

import '../../core/controller/claims_controller.dart';
import '../event_modify.dart';
import 'colors_cons.dart';

class EventTable extends StatelessWidget {
  final events;
  EventTable({
    Key? key, this.events,
  }) : super(key: key);
  final formController = Get.put(FormController());

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
            "Demandes récentes",
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
                    label: Text("titre d'événement"),
                  ),
                  DataColumn(
                    label: Text("Région d’événement"),
                  ),
                  DataColumn(
                    label: Text("Organisation d'événement"),
                  ),
                  DataColumn(
                    label: Text("Date d'événement"),
                  ),
                  DataColumn(
                    label: Text("Opération"),
                  ),
                ],
                rows: List.generate(
                  events.length,
                  (index) => recentUserDataRow(
                      events[index], context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentUserDataRow(Event event, BuildContext context) {
  final formController = Get.put(FormController());

  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.lightBlueAccent.withOpacity(0.2)),
              child: Icon(
                Icons.event,
                color: Colors.lightBlue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                event.title_en!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),

      DataCell(Text(event.location_en!)),
      DataCell(Container(
        width: 100,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.lightBlue.withOpacity(.2),
            border: Border.all(color: Colors.lightBlue),
            borderRadius: BorderRadius.all(Radius.circular(5.0) //
            ),
          ),
          child: Text(event.organization!,textAlign: TextAlign.center,))),
      DataCell(Text(event.date_deb!)),
      DataCell(
        Row(
          children: [
            TextButton(
              child: Text('Vue', style: TextStyle(color: greenColor)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FormEventModifyScreen(event: event,)));
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
                                    "Voulez-vous vraiment supprimer '${event.title_en}'?"),
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
                                          await  formController.removeEvent(event.id);
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
