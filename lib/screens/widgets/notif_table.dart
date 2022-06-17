import 'package:admin_toutn/core/controller/claims_controller.dart';
import 'package:admin_toutn/core/model/notification.dart' as nf;
import 'package:admin_toutn/screens/widgets/claim_table.dart';
import 'package:admin_toutn/screens/widgets/colors_cons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controller/notif_controller.dart';

class NotificationTable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NotificationTableState();
}

class NotificationTableState extends State<NotificationTable> {
  final notifController = Get.put(NotificationsController());

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
            "Notification envoyée récemment",
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
                    label: Text("Titre de la notification"),
                  ),
                  DataColumn(
                    label: Text("Description de la notification"),
                  ),
                  DataColumn(
                    label: Text("Type de notification"),
                  ),
                  DataColumn(
                    label: Text("date d'envoi"),
                  ),
                  DataColumn(
                    label: Text("opération"),
                  ),
                ],
                rows: List.generate(
                  notifController.notifs.length,
                      (index) => recentUserDataRow(
                      notifController.notifs[index], context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentUserDataRow(nf.Notification notif, BuildContext context) {
  final notifController = Get.put(NotificationsController());

  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(5),
                  color: Colors.green.withOpacity(0.2)),
              child: Icon(Icons.notifications_active_sharp,color: Colors.green,),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                notif.title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(notif.description!)),
      DataCell(Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.lightBlue.withOpacity(.2),
            border: Border.all(color: Colors.lightBlue),
            borderRadius: BorderRadius.all(Radius.circular(5.0) //
            ),
          ),
          child: Text(notif.type!))),

      DataCell(Text(notif.date!)),
      DataCell(
        Row(
          children: [
            Icon(Icons.refresh,color: Colors.green,),
            TextButton(
              child: Text('Renvoyer', style: TextStyle(color: greenColor)),
              onPressed: () async{
                await notifController.resendNotif(notif);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title:  Center(
                        child: Column(
                          children: [
                            Icon(Icons.check_circle,
                                size: 36, color: Colors.green),
                            SizedBox(height: 20),
                            Text("Réussi"),
                          ],
                        ),
                      ),
                      content: Text('Votre notification a été envoyée.'),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        FlatButton(
                          child: Text('Fermer'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );

              },
            )
          ],
        ),
      ),
    ],
  );
}