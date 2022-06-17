// @dart=2.9

import 'package:admin_toutn/core/controller/api_controller.dart';
import 'package:admin_toutn/core/model/monument.dart';
import 'package:admin_toutn/screens/widgets/empty_state.dart';
import 'package:admin_toutn/screens/widgets/monuments_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_theme.dart';
import 'monuments_listing.dart';

class MultiForm extends StatefulWidget {
  final index;

  const MultiForm({Key key, this.index}) : super(key: key);

  @override
  _MultiFormState createState() => _MultiFormState();
}

class _MultiFormState extends State<MultiForm> {
  List<MonumentForm> monuments = [];
  int i = 0;
  TextEditingController name_ar, url_drive, name_fr, name_en, lat, long;
  List<dynamic> monumentsdata = [];
  final placecontroller = Get.put(PlacesController());

  @override
  void initState() {
    // TODO: implement initState

    placecontroller.detail != null
        ? placecontroller.detail.monument.isNotEmpty
            ? monumentsdata = placecontroller.detail.monument
            : null
        : null;
    name_ar = TextEditingController(
        text: widget.index != null ? monumentsdata[widget.index].name_ar : '');
    name_fr = TextEditingController(
        text: widget.index != null ? monumentsdata[widget.index].name_fr : '');
    name_en = TextEditingController(
        text: widget.index != null ? monumentsdata[widget.index].name_en : '');
    url_drive = TextEditingController(
        text: widget.index != null
            ? monumentsdata[widget.index].image ==
                    "https://www.justecause.fr/wp-content/uploads/2017/10/temple-grec-300x235.png"
                ? ""
                : monumentsdata[widget.index].image.substring(43)
            : '');
    lat = TextEditingController(
        text: widget.index != null ? monumentsdata[widget.index].lat : '');
    long = TextEditingController(
        text: widget.index != null ? monumentsdata[widget.index].long : '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.choice1,
          child: widget.index != null
              ? IconButton(
                  icon: Icon(Icons.check),
                  color: AppTheme.backgroundWhite,
                  onPressed: () {
                    monumentsdata[widget.index] = Monument(
                        image: "https://drive.google.com/uc?export=view&id=" +
                            url_drive.text,
                        name_ar: name_ar.text,
                        name_en: name_en.text,
                        name_fr: name_fr.text,
                        long: long.text,
                        lat: lat.text,
                        type: "monument");
                    placecontroller.setMonumentUpdate(monumentsdata);
                    Navigator.pop(context);

                    /* Navigator.push(
                      context,
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (_) => MonumentListing(
                          monuments: monumentsdata,
                        ),
                      ),
                    );*/
                  },
                )
              : IconButton(
                  icon: Icon(Icons.add),
                  color: AppTheme.backgroundWhite,
                  onPressed: onAddForm,
                ),
        ),
        appBar: widget.index != null
            ? null
            : AppBar(
                backgroundColor: AppTheme.backgroundWhite,
                elevation: .0,
                leading: Icon(
                  Icons.wb_cloudy,
                ),
                title: Text('Add monuments'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('save'),
                    textColor: AppTheme.choice1,
                    onPressed: onSave,
                  )
                ],
              ),
        body: Container(
            decoration: BoxDecoration(color: AppTheme.backgroundWhite),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: MonumentForm(
              lat: lat,
              long: long,
              name_ar: name_ar,
              name_fr: name_fr,
              name_en: name_en,
              url_drive: url_drive,
              index: widget.index != null
                  ? widget.index
                  : (placecontroller.detail != null
                      ? (placecontroller.detail.monument.isEmpty
                          ? i
                          : placecontroller.detail.monument.length + i)
                      : i),
            )
            /*monuments.isEmpty
          ? Center(
              child: Column(
              children: [
                EmptyState(
                  title: 'Oops',
                  message: 'Add form by tapping add button below',
                ),
                GestureDetector(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      decoration: BoxDecoration(
                          color: Color(0xffc16161),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        'Submit',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: onAddForm)
              ],
            ))
          : ListView.builder(
        //shrinkWrap: true,
              addAutomaticKeepAlives: true,
              scrollDirection: Axis.horizontal,
              itemCount: monuments.length,
              itemBuilder: (_, i) => monuments[i],
            ),*/
            ));
  }

  ///on form user deleted
  void onDelete(Monument _user) {
    setState(() {
      /*var find = monuments.firstWhere(
        (it) => it.monument == _user,
        orElse: () => null,
      );*/
      /* if (find != null) {
        monuments.removeAt(monuments.indexOf(find));
        i--;
      }*/
    });
  }

  ///on add form
  void onAddForm() {
    print(url_drive.text);
    print(lat.text);
    print(long.text);
    print(name_fr.text);
    print(name_ar.text);
    print(name_en.text);

    setState(() {
      i++;
    });

    setState(() {
      monumentsdata.add(Monument(
          image: "https://drive.google.com/uc?export=view&id=" + url_drive.text,
          name_ar: name_ar.text,
          name_en: name_en.text,
          name_fr: name_fr.text,
          long: long.text,
          lat: lat.text,
          type: "monument"));
      name_ar = TextEditingController();
      name_fr = TextEditingController();
      name_en = TextEditingController();
      url_drive = TextEditingController();
      lat = TextEditingController();
      long = TextEditingController();

      /*var _user = Monument();
      monuments.add(MonumentForm(
        monument: _user,
        onDelete: () => onDelete(_user),
      ));*/
    });
    print(i);
    for (var el in monumentsdata) {
      print(el.image);
      print(el.name_ar);
      print(el.name_en);
      print(el.name_fr);
      print(el.type);
    }
  }

  ///on save forms
  void onSave() {
    setState(() {
      monumentsdata.add(Monument(
          image: "https://drive.google.com/uc?export=view&id=" + url_drive.text,
          name_ar: name_ar.text,
          name_en: name_en.text,
          name_fr: name_fr.text,
          long: long.text,
          lat: lat.text,
          type: "monument"));
      name_ar = TextEditingController();
      name_fr = TextEditingController();
      name_en = TextEditingController();
      url_drive = TextEditingController();
      lat = TextEditingController();
      long = TextEditingController();
    });
    if (monumentsdata.length > 0) {
      /* var allValid = true;
      monuments.forEach((form) => allValid = allValid && form.isValid());*/

      monumentsdata.removeWhere(
          (element) => (element.long.isEmpty || element.lat.isEmpty));
      placecontroller.setMonumentUpdate(monumentsdata);
      var data = monumentsdata;
      Navigator.pop(context);

      /*Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => MonumentListing(
            monuments: data,
          ),
        ),
      );*/
    }
  }
}
