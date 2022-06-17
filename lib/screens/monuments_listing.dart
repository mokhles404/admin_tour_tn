// @dart=2.9

import 'package:admin_toutn/app_theme.dart';
import 'package:admin_toutn/core/controller/api_controller.dart';
import 'package:admin_toutn/screens/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_monuments_screen.dart';
import 'add_one_site.dart';

class MonumentListing extends StatefulWidget {
  final monuments;

  const MonumentListing({Key key, this.monuments}) : super(key: key);

  MonumentListingState createState() => MonumentListingState();
}

class MonumentListingState extends State<MonumentListing> {
  final placecontroller = Get.put(PlacesController());

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
        "supprimer",
        style: TextStyle(color: AppTheme.choice1),
      ),
      onPressed: () {
        //delete logic
        //await placecontroller.deleteSite(id);
        var temp = placecontroller.monumentUpdate;
        temp.removeAt(id);
        placecontroller.setMonumentUpdate(temp);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title:
          Text("Supprimer cet élément", style: TextStyle(color: AppTheme.choice1)),
      content: Text("Êtes-vous sûr de bien vouloir supprimer cet élément?"),
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
    return GetBuilder<PlacesController>(builder: (_) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: AppTheme.choice1,
            child: IconButton(
              icon: Icon(Icons.check),
              color: AppTheme.backgroundWhite,
              onPressed: () {
                Navigator.pop(context);

                /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddOneSite(
                          update: true,
                        )));*/
              },
            )),
        appBar: AppBar(
          backgroundColor: Color(0xfff9f9f9),
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 35,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.add,
                size: 35,
                color: AppTheme.choice1,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiForm(),
                  ),
                );
              },
            ),
          ],
          title: Text(
            'List of monuments',
            style: TextStyle(color: Color(0xffc16161)),
          ),
        ),
        body: _.monumentUpdate.isEmpty
            ? EmptyState(
                title: "La liste est vide !",
                message: "Vous pouvez ajouter autant de monuments que vous voulez.",
              )
            : ListView.builder(
                itemCount: _.monumentUpdate.length,
                itemBuilder: (ctx, i) => Container(
                    height: 120,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MultiForm(
                                      index: i,
                                    )));
                      },
                      child: ListTile(
                        leading: Container(
                          height: MediaQuery.of(context).size.width / 4,
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                )
                              ],
                              image: DecorationImage(
                                  image: NetworkImage(
                                    _.monumentUpdate[i].image,
                                  ),
                                  fit:  _.monumentUpdate[i].image ==
                                      "https://www.justecause.fr/wp-content/uploads/2017/10/temple-grec-300x235.png"
                                      ?BoxFit.contain:BoxFit.cover)),
                        ),
                        title: Text(
                          _.monumentUpdate[i].name_en,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Questrial',
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          _.monumentUpdate[i].type,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Questrial',
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: GestureDetector(
                          onTap: () async {
                            showAlertDialog(context, i);

                            /* await _.deleteSite(_.places[index].id);
                            _.setplaces(index);*/

                            //  await _.removeEvent(_.eventsList[index].id);
                          },
                          child: Icon(
                            Icons.delete,
                            color: Color(0xffc16161),
                            size: 30,
                          ),
                        ),
                      ),
                    ))),
      );
    });
  }
}
