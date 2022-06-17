import 'package:admin_toutn/core/controller/api_controller.dart';
import 'package:admin_toutn/screens/imma_table.dart';
import 'package:admin_toutn/screens/widgets/colors_cons.dart';
import 'package:admin_toutn/screens/widgets/monuments_form.dart';
import 'package:admin_toutn/screens/widgets/sites_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_toutn/core/controller/form_controller.dart';
import '../app_theme.dart';
import '../core/controller/edit_immat_controller.dart';
import 'add_monuments_screen.dart';
import 'add_one_site.dart';
import 'event_form.dart';
import 'event_modify.dart';
import 'imma_edit_form.dart';
import 'notification_form.dart';

class ImmaList extends StatefulWidget {
  _ImmaListState createState() => _ImmaListState();
}

class _ImmaListState extends State<ImmaList> {
  final immaController = Get.put(FormController());

  TextEditingController searchController = TextEditingController();

  showAlertDialog(BuildContext context, id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Annuler"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Supprimer",
        style: TextStyle(color: AppTheme.choice1),
      ),
      onPressed: () async {
        //delete logic

        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title:
      Text("Supprimer cet élément", style: TextStyle(color: AppTheme.choice1)),
      content: Text("Êtes-vous sûr de vouloir supprimer cet élément ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetBuilder<ImmatController>(builder: (_) {
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

            title: Text(
              'Liste du patrimoine immatériel',
              style: TextStyle(color: Color(0xffc16161)),
            ),
          ),
          body: SafeArea(
              child: SingleChildScrollView(
                //padding: EdgeInsets.all(defaultPadding),
                  child: Container(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width/3,
                                  padding: EdgeInsets.only(right: 30),
                                  child: TextField(
                                    onChanged: (val) {
                                      _.setQueryImma(val);
                                    },
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      hintText: "Chercher",
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[200]!,
                                            width: 0.5,
                                            style: BorderStyle.none),
                                        borderRadius:
                                        const BorderRadius.all(Radius.circular(10)),
                                      ),
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          _.setQueryImma(searchController.text);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          margin: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0xffc16161).withOpacity(
                                                0.2),
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          child: Icon(
                                            Icons.search,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap:  () {
                                        _.setImagesUpdate([]);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>EditFormImmat(update: false,)));
                                      },
                                      child: Material(
                                        shadowColor: Colors.grey,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        color: Color(0xffc16161),
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          alignment: Alignment.center,
                                          height: 35,
                                          width: 200,
                                          child: Text(
                                            'ajouter un élément',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                            SizedBox(
                              height: 20,
                            ),
                            _.queryImma.isEmpty
                                ? FutureBuilder(
                                future: _.getImmaPatri(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasError)
                                    return Text(snapshot.error.toString());
                                  if (snapshot.hasData) {
                                    /*print("list length" + snapshot.data.length.toString());
                  return ListView.builder(
                      itemCount: _.places.length,
                      itemBuilder: (context, index) {
                        return Container(
                            height: 120,
                            child: GestureDetector(
                              onTap: () {

                                placecontroller.setDetail(_.places[index]);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddOneSite(
                                              update: true,
                                            )));
                              },
                              child: ListTile(
                                leading: Container(
                                  height: 120,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                        )
                                      ],
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            _.places[index].images[0],
                                          ),
                                          fit: BoxFit.cover)),
                                ),
                                title: Text(
                                  _.places[index].name_en,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Questrial',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 25,
                                      width:_.places[index].jour_ferm.isNotEmpty
                                          ? (_.places[index].jour_ferm.any((element) => element.toLowerCase() ==
                                          "maintenance")
                                          ? 30:20):20,
                                      child: Image.asset(
                                        _.places[index].jour_ferm.isNotEmpty
                                            ? (_.places[index].jour_ferm.any((element) => element.toLowerCase() ==
                                            "maintenance")
                                            ? "assets/blocked.png"
                                            : "assets/unblocked.png")
                                            : "assets/unblocked.png"
                                        ,
                                        fit: BoxFit.contain,
                                        color:
                                        _.places[index].jour_ferm.isNotEmpty
                                            ? (_.places[index].jour_ferm.any((element) => element.toLowerCase() ==
                                            "maintenance")
                                            ? null
                                            : Colors.green)
                                            : Colors.green,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      _.places[index].jour_ferm.isNotEmpty
                                          ? (_.places[index].jour_ferm.any((element) => element.toLowerCase() ==
                                          "maintenance")
                                          ? "in maintenance"
                                          : "open")
                                          : "open",
                                      style: TextStyle(
                                          color:
                                          _.places[index].jour_ferm.isNotEmpty
                                              ? (_.places[index].jour_ferm.any((element) => element.toLowerCase() ==
                                              "maintenance")
                                              ? Color(0xffc16161)
                                              : Colors.green)
                                              : Colors.green,
                                          fontFamily: 'Questrial',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),

                                trailing: GestureDetector(
                                  onTap: () async {
                                    showAlertDialog(context,_.places[index].id);

                                    //  await _.removeEvent(_.eventsList[index].id);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Color(0xffc16161),
                                    size: 30,
                                  ),
                                ),
                              ),
                            ));
                      });*/
                                    print(_.ImmaList.length);
                                    return ImmaTable(
                                      immas: _.ImmaList,
                                    );
                                  } else
                                    return Center(
                                        child: CircularProgressIndicator());
                                })
                                : ImmaTable(
                              immas: _.ImmaList
                                  .where((element) =>
                              (element.name_en.toLowerCase().contains(
                                  _.queryImma) ||
                                  element.name_fr.toLowerCase().contains(
                                      _.queryImma) ||
                                  element.name_ar.toLowerCase().contains(
                                      _.queryImma)))
                                  .toList(),
                            )
                          ])))));
    });
  }
}
