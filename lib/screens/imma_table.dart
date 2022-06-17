import 'package:admin_toutn/core/controller/edit_immat_controller.dart';
import 'package:admin_toutn/core/model/Reclamation.dart';
import 'package:admin_toutn/core/model/imaa_patri.dart';
import 'package:admin_toutn/screens/widgets/colors_cons.dart';
import 'package:flutter/material.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/controller/api_controller.dart';
import '../../core/model/site.dart';
import '../core/controller/form_controller.dart';
import 'imma_edit_form.dart';


class ImmaTable extends StatelessWidget {
  final immas;
  ImmaTable({
    Key? key, this.immas,
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
            "List of Immaterial Heritage",
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
                    label: Text(" "),
                  ),
                  DataColumn(
                    label: Text("Nom"),
                  ),
                  DataColumn(
                    label: Text("Lien"),
                  ),

                  DataColumn(
                    label: Text("Opération"),
                  ),
                ],
                rows: List.generate(
                  immas.length,
                      (index) => recentUserDataRow(
                      immas[index], context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentUserDataRow(Immat site, BuildContext context) {
  final formcontroller = Get.put(ImmatController());
  return DataRow(
    cells: [
      DataCell(
       Container(
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(8),
           image: DecorationImage(
             image: NetworkImage(site.images[0]),
             fit: BoxFit.cover
           )
         ),
         height: 35,
         width: 35,
       )
      ),
      DataCell(Text(
        site.name_en!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),),
      DataCell( TextButton(
        child: Text(site.source_en, style: TextStyle(color: Colors.lightBlue)),
        onPressed: () => launch(site.source_en)
      ),),
      DataCell(
        Row(
          children: [
            TextButton(
              child: Text('Vue', style: TextStyle(color: greenColor)),
              onPressed: () {
                formcontroller.setDetail(site);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditFormImmat(update: true,)));
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
                                Text("confirmer la suppression"),
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
