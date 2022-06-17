// @dart=2.9

import 'package:admin_toutn/core/controller/api_controller.dart';
import 'package:admin_toutn/screens/add_monuments_screen.dart';
import 'package:admin_toutn/screens/widgets/textfield_tour_custom.dart';
import 'package:admin_toutn/screens/widgets/textformfield_custom.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_multi_carousel/carousel.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../app_theme.dart';
import '../main.dart';
import 'dashboard.dart';
import 'monuments_listing.dart';

class AddOneSite extends StatefulWidget {
  final bool update;

  AddOneSite({Key key, this.update}) : super(key: key);

  @override
  AddOneSiteState createState() => AddOneSiteState();
}

class AddOneSiteState extends State<AddOneSite> {
  String dropdownvalue = 'NO';
  var items = [
    'NO',
    'NE',
    'CO',
    'CE',
    'SO',
    'SE',
  ];
  List<dynamic> types = [], epoques = [], jours = [];
  TextEditingController name_ar,
      url_drive,
      name_fr,
      name_en,
      desc_fr,
      desc_en,
      desc_ar,
      ville,
      gouv_ar,
      gouv,
      ville_ar,
      time_ete,
      time_hiver,
      time_ramad,
      organization,
      source_fr,
      source_en,
      source_ar,
      jour_ferm,
      lat,
      long,
      frais_res,
      frais_etr,
      region;
  var reg = 'NO';
  final _formKey = GlobalKey<FormState>();
  static List<String> friendsList = [];
  static List<String> toursList = [];
  List<bool> _isSelected = [false, true, false, true, true];
  List<bool> _isSelected2 = [true, false, false, false, false, false];
  List<bool> _isSelected3 = [false, false, false, false];
  List<bool> _isSelected4 = [false, false, false];
  final placecontroller = Get.put(PlacesController());
  bool checkedValue;

  @override
  void initState() {
    // TODO: implement initState
    checkedValue = (widget.update) ? placecontroller.detail.patrimoine : false;
    dropdownvalue = (widget.update) ? placecontroller.detail.region : 'NO';
    epoques = !(widget.update)
        ? ["antiquite", "contemporaine", "moyen-âge"]
        : placecontroller.detail.epoque;
    jours = !(widget.update)
        ? ["lundi", "vendredi", "dimanche", "samedi"]
        : placecontroller.detail.jour_ferm;
    types = !(widget.update)
        ? ["site", "monument", "musee", "ensemble"]
        : placecontroller.detail.type.split(';');
    _isSelected = [
      widget.update ? placecontroller.toilette : false,
      widget.update ? placecontroller.cafeteria : false,
      widget.update ? placecontroller.boutique : false,
      widget.update ? placecontroller.park : false,
      widget.update ? placecontroller.ascenseurs : false
    ];
    _isSelected2 = [
      widget.update ? placecontroller.detail.region.contains('NE') : false,
      widget.update ? placecontroller.detail.region.contains('NO') : false,
      widget.update ? placecontroller.detail.region.contains('CE') : false,
      widget.update ? placecontroller.detail.region.contains('CO') : false,
      widget.update ? placecontroller.detail.region.contains('SE') : false,
      widget.update ? placecontroller.detail.region.contains('SO') : false,
    ];
    _isSelected3 = [
      widget.update ? placecontroller.detail.type.contains('site') : false,
      widget.update ? placecontroller.detail.type.contains('musee') : false,
      widget.update ? placecontroller.detail.type.contains('monument') : false,
      widget.update ? placecontroller.detail.type.contains('ensemble') : false,
    ];
    _isSelected4 = [
      widget.update
          ? placecontroller.detail.epoque.contains('antiquite')
          : false,
      widget.update
          ? placecontroller.detail.epoque.contains('moyen-âge')
          : false,
      widget.update
          ? placecontroller.detail.epoque.contains('contemporaine')
          : false,
    ];

    name_ar = TextEditingController(
        text: widget.update ? placecontroller.detail.name_ar : "");
    frais_res = TextEditingController(
        text: widget.update ? placecontroller.detail.frais_resident : "");
    frais_etr = TextEditingController(
        text: widget.update ? placecontroller.detail.frais_etranger : "");
    region = TextEditingController(
        text: widget.update ? placecontroller.detail.region : "");
    url_drive = TextEditingController();
    name_fr = TextEditingController(
        text: widget.update ? placecontroller.detail.name_fr : "");
    name_en = TextEditingController(
        text: widget.update ? placecontroller.detail.name_en : "");
    desc_fr = TextEditingController(
        text: widget.update ? placecontroller.detail.description_fr : "");
    desc_en = TextEditingController(
        text: widget.update ? placecontroller.detail.description_en : "");
    desc_ar = TextEditingController(
        text: widget.update ? placecontroller.detail.description_ar : "");
    ville = TextEditingController(
        text: widget.update ? placecontroller.detail.ville : "");
    gouv_ar = TextEditingController(
        text: widget.update ? placecontroller.detail.gouvernorat_ar : "");
    gouv = TextEditingController(
        text: widget.update ? placecontroller.detail.gouvernorat : "");
    ville_ar = TextEditingController(
        text: widget.update ? placecontroller.detail.ville_ar : "");
    time_ete = TextEditingController(
        text: widget.update ? placecontroller.detail.horaire_ete : "");
    time_hiver = TextEditingController(
        text: widget.update ? placecontroller.detail.horaire_hiver : "");
    time_ramad = TextEditingController(
        text: widget.update ? placecontroller.detail.horaire_ramadan : "");
    organization = TextEditingController(text: widget.update ? "" : "");
    source_fr = TextEditingController(
        text: widget.update ? placecontroller.detail.source_fr : "");
    source_en = TextEditingController(
        text: widget.update ? placecontroller.detail.source_en : "");
    source_ar = TextEditingController(
        text: widget.update ? placecontroller.detail.source_ar : "");
    jour_ferm = TextEditingController(
        text: widget.update
            ? placecontroller.detail.jour_ferm.isNotEmpty
                ? placecontroller.detail.jour_ferm[0]
                : ""
            : "");
    lat = TextEditingController(
        text: widget.update ? placecontroller.detail.lat : "");
    long = TextEditingController(
        text: widget.update ? placecontroller.detail.long : "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetBuilder<PlacesController>(builder: (_) {
      return Scaffold(
          backgroundColor: Color(0xfff9f9f9),
          appBar: AppBar(
            backgroundColor: Color(0xfff9f9f9),
            elevation: 0.0,
            actions: [
              widget.update
                  ? IconButton(
                      icon: _.maintenanceUpdate
                          ? SizedBox(
                              height: 35,
                              width: 35,
                              child: Image.asset(
                                "assets/blocked.png",
                              ),
                            )
                          : SizedBox(
                              height: 35,
                              width: 35,
                              child: Image.asset(
                                "assets/unblocked.png",
                                color: Colors.green,
                              ),
                            ),
                      onPressed: () async {
                        if (_.maintenanceUpdate) {
                          //TODO open this site
                          _.setMaintenanceUpdate(!_.maintenanceUpdate);
                          var temp = _.joursUpdate;
                          temp.remove("maintenance");
                          _.setJoursUpdate(temp);
                          await _.updateSite(
                              {'jour_ferm': _.joursUpdate.join(";")},
                              _.detail.id);
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()));*/
                        } else {
                          //TODO close this site
                          _.setMaintenanceUpdate(!_.maintenanceUpdate);
                          var temp = _.joursUpdate;
                          temp.add("maintenance");
                          _.setJoursUpdate(temp);
                          await _.updateSite(
                              {'jour_ferm': _.joursUpdate.join(";")},
                              _.detail.id);
                          /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()));*/
                        }
                      },
                    )
                  : Container()
            ],
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
            title: Text(
              widget.update ? "Mettre à jour le lieu" : 'Ajouter un lieu',
              style: TextStyle(color: Color(0xffc16161)),
            ),
          ),
          body: _.isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Form(
                  key: _formKey,
                  child: ListView(children: <Widget>[
                    //  Text('Add pics', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                    /* Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),*/
                    GestureDetector(
                        onTap: () {
                          //TODO update password page
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MonumentListing(
                                    monuments: _.monumentUpdate,
                                  )));
                        },
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                                width: 160,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        AppTheme.choice1.withOpacity(0.3),
                                        AppTheme.choice2.withOpacity(0.2)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                  border: Border.all(
                                    color: AppTheme.choice1,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.account_balance,
                                      color: AppTheme.choice1,
                                    ),
                                    Text(
                                        (_.monumentUpdate.isEmpty ||
                                                widget.update == false)
                                            ? "ajouter monuments"
                                            : "${_.monumentUpdate.length} monuments",
                                        style:
                                            TextStyle(color: AppTheme.choice1)),
                                  ],
                                )))),
                    SizedBox(
                      height: 10,
                    ),
                    _.imagesUpdate.isNotEmpty
                        ? Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[100],
                                  spreadRadius: 2,
                                  blurRadius: 5)
                            ], borderRadius: BorderRadius.circular(15)),
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 4),
                            child: Stack(
                              children: [
                                Carousel(
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    width: MediaQuery.of(context).size.width,
                                    initialPage: 0,
                                    allowWrap: true,
                                    type: Types.simple,
                                    onCarouselTap: (i) {
                                      print("onTap $i");
                                    },
                                    indicatorBackgroundOpacity: 0,
                                    indicatorType: IndicatorTypes.bar,
                                    arrowColor: AppTheme.choice1,
                                    indicatorBackgroundColor:
                                        AppTheme.backgroundWhite,
                                    activeIndicatorColor: AppTheme
                                        .backgroundWhite
                                        .withOpacity(0.8),
                                    unActiveIndicatorColor:
                                        AppTheme.choice1.withOpacity(0.3),
                                    axis: Axis.horizontal,
                                    showArrow: true,
                                    children: List.generate(
                                        _.imagesUpdate.length,
                                        (i) => Center(
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color:
                                                              Colors.grey[100],
                                                          spreadRadius: 2,
                                                          blurRadius: 5)
                                                    ],
                                                    image: DecorationImage(
                                                        onError:
                                                            (object, stack) {
                                                          print("error image" +
                                                              stack.toString());
                                                        },
                                                        image: NetworkImage(
                                                            _.imagesUpdate[i]),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        // TODO delete picture from list
                                                        var temp =
                                                            _.imagesUpdate;
                                                        temp.removeAt(i);
                                                        _.setImagesUpdate(temp);
                                                      },
                                                      child: Icon(
                                                        Icons.delete,
                                                        color: AppTheme.choice1
                                                            .withOpacity(0.8),
                                                        size: 30,
                                                      ),
                                                    )),
                                              ),
                                            ))),
                                /* Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () async {
                                  /*  if (_.favoritesId.contains(_.detail.id)) {
                                //TODO remove from fav
                                await _.removeFav(_.detail);
                                print("doesn't exist");
                              } else {
                                _.setFavorite(_.detail);
                                await _.addTofav();
                                print(_.favorites.contains(_.detail.id));
                              }*/
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: AppTheme.choice1.withOpacity(0.8),
                                  size: 30,
                                ),
                              )),*/
                              ],
                            ))
                        : Container(),

                    friendsList.isNotEmpty
                        ? Container()
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {
                                  friendsList.add(null);
                                  setState(() {});
                                },
                                child: Container(
                                    width: 120,
                                    height: 35,
                                    margin: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Color(0xfff6fafd),
                                      borderRadius: BorderRadius.circular(20),
                                      border:
                                          Border.all(color: Color(0xffe8ecef)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: 30,
                                          color: Color(0xffc16161),
                                        ),
                                        Text(
                                          "Ajouter image",
                                          style:
                                              TextStyle(color: Colors.black45),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          ),
                    ..._getFriends(false),
                    _.images360Update.isNotEmpty
                        ? Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[100],
                                  spreadRadius: 2,
                                  blurRadius: 5)
                            ], borderRadius: BorderRadius.circular(15)),
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 4),
                            child: Stack(
                              children: [
                                Carousel(
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    width: MediaQuery.of(context).size.width,
                                    initialPage: 0,
                                    allowWrap: true,
                                    type: Types.simple,
                                    onCarouselTap: (i) {
                                      print("onTap $i");
                                    },
                                    indicatorBackgroundOpacity: 0,
                                    indicatorType: IndicatorTypes.bar,
                                    arrowColor: AppTheme.choice1,
                                    indicatorBackgroundColor:
                                        AppTheme.backgroundWhite,
                                    activeIndicatorColor: AppTheme
                                        .backgroundWhite
                                        .withOpacity(0.8),
                                    unActiveIndicatorColor:
                                        AppTheme.choice1.withOpacity(0.3),
                                    axis: Axis.horizontal,
                                    showArrow: true,
                                    children: List.generate(
                                        _.images360Update.length,
                                        (i) => Center(
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color:
                                                              Colors.grey[100],
                                                          spreadRadius: 2,
                                                          blurRadius: 5)
                                                    ],
                                                    image: DecorationImage(
                                                        onError:
                                                            (object, stack) {
                                                          print("error image" +
                                                              stack.toString());
                                                        },
                                                        image: NetworkImage(
                                                            _.images360Update[
                                                                i]),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        // TODO delete picture from list
                                                        var temp =
                                                            _.images360Update;
                                                        temp.removeAt(i);
                                                        _.setImages360Update(
                                                            temp);
                                                      },
                                                      child: Icon(
                                                        Icons.delete,
                                                        color: AppTheme.choice1
                                                            .withOpacity(0.8),
                                                        size: 30,
                                                      ),
                                                    )),
                                              ),
                                            ))),
                                /* Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () async {
                                  /*  if (_.favoritesId.contains(_.detail.id)) {
                                //TODO remove from fav
                                await _.removeFav(_.detail);
                                print("doesn't exist");
                              } else {
                                _.setFavorite(_.detail);
                                await _.addTofav();
                                print(_.favorites.contains(_.detail.id));
                              }*/
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: AppTheme.choice1.withOpacity(0.8),
                                  size: 30,
                                ),
                              )),*/
                              ],
                            ))
                        : Container(),
                    toursList.isNotEmpty
                        ? Container()
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {
                                  toursList.add(null);
                                  setState(() {});
                                },
                                child: Container(
                                    width: 120,
                                    height: 35,
                                    margin: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Color(0xfff6fafd),
                                      borderRadius: BorderRadius.circular(20),
                                      border:
                                          Border.all(color: Color(0xffe8ecef)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: 30,
                                          color: Color(0xffc16161),
                                        ),
                                        Text(
                                          "Ajouter 360°",
                                          style:
                                              TextStyle(color: Colors.black45),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          ),
                    ..._getFriends(true),
                    Container(
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        /* decoration: BoxDecoration(
                          color: Color(0xfff6fafd),
                          border: Border.all(color: Color(0xffe8ecef)),
                          borderRadius: BorderRadius.circular(10),
                        ),*/
                        child: CheckboxListTile(
                          title: Text("héritage du monde"),
                          value: checkedValue,
                          onChanged: (newValue) {
                            setState(() {
                              checkedValue = newValue;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        )),
                    Center(
                      child: ToggleButtons(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Antiquité"),
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Moyen-âge")),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Contemporaine")),
                        ],
                        isSelected: _isSelected4,
                        onPressed: (int index) {
                          setState(() {
                            _isSelected4[index] = !_isSelected4[index];
                          });
                          if (_isSelected4[index]) {
                            var temp = _.epoUpdate;
                            if (index == 0) {
                              temp.add("antiquite");
                            }
                            if (index == 1) {
                              temp.add("moyen-âge");
                            }
                            if (index == 2) {
                              temp.add("contemporaine");
                            }

                            _.setEpoUpdate(temp);
                          } else {
                            var temp = _.epoUpdate;
                            if (index == 0) {
                              temp.remove("antiquite");
                            }
                            if (index == 1) {
                              temp.remove("moyen-âge");
                            }
                            if (index == 2) {
                              temp.remove("contemporaine");
                            }

                            _.setEpoUpdate(temp);
                            print(_.epoUpdate);
                          }
                        },
                        color: Colors.grey,
                        selectedColor: Colors.red[900],
                        fillColor: Colors.red[900].withOpacity(0.3),
                        borderColor: Colors.grey,
                        selectedBorderColor: Colors.red[900].withOpacity(0.8),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ToggleButtons(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Site"),
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Musée")),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Monument")),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Ensemble")),
                        ],
                        isSelected: _isSelected3,
                        onPressed: (int index) {
                          setState(() {
                            _isSelected3[index] = !_isSelected3[index];
                          });
                          if (_isSelected3[index]) {
                            var temp = _.typesUpdate;
                            if (index == 0) {
                              temp.add("site");
                            }
                            if (index == 1) {
                              temp.add("musee");
                            }
                            if (index == 2) {
                              temp.add("monument");
                            }
                            if (index == 3) {
                              temp.add("ensemble");
                            }
                            print(temp);
                            _.setTypesUpdate(temp);
                          } else {
                            var temp = _.typesUpdate;
                            if (index == 0) {
                              temp.remove("site");
                            }
                            if (index == 1) {
                              temp.remove('musee');
                            }
                            if (index == 2) {
                              temp.remove("monument");
                            }
                            if (index == 3) {
                              temp.removeAt(3);
                            }
                            if (index == 4) {
                              temp.remove("ensemble");
                            }
                            _.setTypesUpdate(temp);
                            print(_.typesUpdate);
                          }
                        },
                        color: Colors.grey,
                        selectedColor: Colors.red[900],
                        fillColor: Colors.red[900].withOpacity(0.3),
                        borderColor: Colors.grey,
                        selectedBorderColor: Colors.red[900].withOpacity(0.8),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ToggleButtons(
                        children: <Widget>[
                          Icon(Icons.wc),
                          Icon(Icons.coffee),
                          Icon(Icons.shopping_bag_outlined),
                          Icon(Icons.local_parking),
                          Icon(Icons.elevator_outlined),
                        ],
                        isSelected: _isSelected,
                        onPressed: (int index) {
                          setState(() {
                            _isSelected[index] = !_isSelected[index];
                          });
                          if (_isSelected[index]) {
                            var temp = _.commUpdate;
                            if (index == 0) {
                              temp.add("Toilettes");
                            }
                            if (index == 1) {
                              temp.add("Cafétéria");
                            }
                            if (index == 2) {
                              temp.add("Boutique");
                            }
                            if (index == 3) {
                              temp.add("Parking");
                            }
                            if (index == 4) {
                              temp.add("Assenceurs");
                            }
                            print(temp);
                            print(_.commUpdate);
                            _.setCommUpdate(temp);
                          } else {
                            var temp = _.commUpdate;
                            if (index == 0) {
                              temp.remove("Toilettes");
                            }
                            if (index == 1) {
                              temp.remove("Cafétéria");
                            }
                            if (index == 2) {
                              temp.remove("Boutique");
                            }
                            if (index == 3) {
                              temp.remove("Parking");
                            }
                            if (index == 4) {
                              temp.remove("Assenceurs");
                            }
                            print(temp);
                            print(_.commUpdate);
                            _.setCommUpdate(temp);
                          }
                        },
                        color: Colors.grey,
                        selectedColor: Colors.red[900],
                        fillColor: Colors.red[900].withOpacity(0.3),
                        borderColor: Colors.grey,
                        selectedBorderColor: Colors.red[900].withOpacity(0.8),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ToggleButtons(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Nord-est"),
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Nord-ouest")),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Centre-est")),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Centre-ouest")),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Sud-est")),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Sud-ouest")),
                        ],
                        isSelected: _isSelected2,
                        onPressed: (int index) {
                          if (_isSelected2[index] == true) {
                            setState(() {
                              _isSelected2[index] = !_isSelected2[index];
                            });
                            _.setRegion('NO');
                          } else {
                            if (_isSelected2
                                    .where((element) => element == true)
                                    .toList()
                                    .length <
                                1) {
                              setState(() {
                                _isSelected2[index] = !_isSelected2[index];
                              });
                              if (_isSelected2[index]) {
                                var temp = "NE";
                                if (index == 0) {
                                  temp = "NE";
                                }
                                if (index == 1) {
                                  temp = "NO";
                                }
                                if (index == 2) {
                                  temp = "CE";
                                }
                                if (index == 3) {
                                  temp = "CO";
                                }
                                if (index == 4) {
                                  temp = "SE";
                                }
                                if (index == 5) {
                                  temp = "SO";
                                }
                                _.setRegion(temp);
                                print(_.region);
                              } else {
                                _.setRegion("NO");
                                print(_.region);
                              }
                            }
                          }
                        },
                        color: Colors.grey,
                        selectedColor: Colors.red[900],
                        fillColor: Colors.red[900].withOpacity(0.3),
                        borderColor: Colors.grey,
                        selectedBorderColor: Colors.red[900].withOpacity(0.8),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.title,
                              color: Color(0xffc16161),
                            ),
                            hintText: "nom en français",
                            labelText: "nom en français",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: name_fr,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.title,
                              color: Color(0xffc16161),
                            ),
                            hintText: "nom en arabe",
                            labelText: "nom en arabe",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: name_ar,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.title,
                              color: Color(0xffc16161),
                            ),
                            hintText: "nom en anglais",
                            labelText: "nom en anglais",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: name_en,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        maxLines: 10,
                        minLines: 5,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.description,
                              color: Color(0xffc16161),
                            ),
                            hintText: "description en français",
                            labelText: "description en français",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: desc_fr,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        maxLines: 10,
                        minLines: 5,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.description,
                              color: Color(0xffc16161),
                            ),
                            hintText: "description en arabe",
                            labelText: "description en arabe",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: desc_ar,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        maxLines: 10,
                        minLines: 5,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.description,
                              color: Color(0xffc16161),
                            ),
                            hintText: "description en anglais",
                            labelText: "description en anglais",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: desc_en,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            icon: SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.asset(
                                "assets/sun.png",
                                color: Color(0xffc16161),
                              ),
                            ),
                            hintText: "heure d'été",
                            labelText: "heure d'été",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: time_ete,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            icon: SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  "assets/rainy.png",
                                  color: Color(0xffc16161),
                                )),
                            hintText: "heure d'hiver",
                            labelText: "heure d'hiver",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: time_hiver,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            icon: SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  "assets/ramadan.png",
                                  color: Color(0xffc16161),
                                )),
                            hintText: "heure du ramadan",
                            labelText: "heure du ramadan",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: time_ramad,
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'lat cannot be empty!';
                          }
                        },
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.location_on,
                              color: Color(0xffc16161),
                            ),
                            hintText: "latitude",
                            labelText: "latitude",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: lat,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'lat cannot be empty!';
                          }
                        },
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.location_on,
                              color: Color(0xffc16161),
                            ),
                            hintText: "longitude",
                            labelText: "longitude",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: long,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            icon: SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  "assets/money.png",
                                  color: Color(0xffc16161),
                                )),
                            hintText: "prix d'entrée résident",
                            labelText: "prix d'entrée résident",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: frais_res,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            icon: SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  "assets/money.png",
                                  color: Color(0xffc16161),
                                )),
                            hintText: "Prix d’entrée étranger",
                            labelText: "Prix d’entrée étranger",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: frais_etr,
                      ),
                    ),
                    /* Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xfff6fafd),
                          border: Border.all(color: Color(0xffe8ecef)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFieldTags(
                            initialTags: !(widget.update)
                                ? ["site", "monument", "musee", "ensemble"]
                                : _.detail.type.split(";"),
                            tagsStyler: TagsStyler(
                              tagTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              tagDecoration: BoxDecoration(
                                color: const Color.fromARGB(255, 171, 81, 81),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              tagCancelIcon: Icon(Icons.cancel,
                                  size: 16.0,
                                  color: Color.fromARGB(255, 235, 214, 214)),
                              tagPadding: const EdgeInsets.all(10.0),
                            ),
                            textFieldStyler: TextFieldStyler(
                              hintText: "Types",
                              helperText:
                                  "What's the type of this place? site,monument,musee,ensemble",
                              isDense: false,
                              textFieldBorder: InputBorder.none,
                              textFieldFocusedBorder: InputBorder.none,
                            ),
                            onTag: (tag) {
                              types.add(tag);
                            },
                            onDelete: (tag) {
                              types.remove(tag);
                            },
                            validator: (tag) {
                              if (tag.length > 15) {
                                return "hey that's too long";
                              }
                              return null;
                            })),*/
                    /* Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xfff6fafd),
                          border: Border.all(color: Color(0xffe8ecef)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFieldTags(
                            initialTags: !(widget.update)
                                ? ["antiquite", "contemporaine", "moyen-âge"]
                                : _.detail.epoque,
                            tagsStyler: TagsStyler(
                              tagTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              tagDecoration: BoxDecoration(
                                color: const Color.fromARGB(255, 171, 81, 81),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              tagCancelIcon: Icon(Icons.cancel,
                                  size: 16.0,
                                  color: Color.fromARGB(255, 235, 214, 214)),
                              tagPadding: const EdgeInsets.all(10.0),
                            ),
                            textFieldStyler: TextFieldStyler(
                              hintText: "Era",
                              isDense: false,
                              helperText:
                                  "To what era this place is related?antiquite,contemporaine,moyen-âge",
                              textFieldBorder: InputBorder.none,
                              textFieldFocusedBorder: InputBorder.none,
                            ),
                            onTag: (tag) {
                              epoques.add(tag);
                            },
                            onDelete: (tag) {
                              epoques.remove(tag);
                            },
                            validator: (tag) {
                              if (tag.length > 15) {
                                return "hey that's too long";
                              }
                              return null;
                            })),*/
                    Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xfff6fafd),
                          border: Border.all(color: Color(0xffe8ecef)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFieldTags(
                            initialTags: !(widget.update)
                                ? ["lundi", "vendredi", "dimanche", "samedi"]
                                : _.detail.jour_ferm,
                            tagsStyler: TagsStyler(
                              tagTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              tagDecoration: BoxDecoration(
                                color: const Color.fromARGB(255, 171, 81, 81),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              tagCancelIcon: Icon(Icons.cancel,
                                  size: 16.0,
                                  color: Color.fromARGB(255, 235, 214, 214)),
                              tagPadding: const EdgeInsets.all(10.0),
                            ),
                            textFieldStyler: TextFieldStyler(
                              contentPadding: EdgeInsets.all(10),
                              helperText:
                                  "quand ce lieu est fermé?lundi,vendredi,dimanche,samedi,maintenance",
                              hintText: "jours de fermeture",
                              isDense: false,
                              textFieldFocusedBorder: InputBorder.none,
                              textFieldBorder: InputBorder.none,
                            ),
                            onTag: (tag) {
                              jours.add(tag);
                            },
                            onDelete: (tag) {
                              jours.remove(tag);
                            },
                            validator: (tag) {
                              if (tag.length > 15) {
                                return "c’est trop long";
                              }
                              return null;
                            })),
                    /*  Container(
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xfff6fafd),
                          border: Border.all(color: Color(0xffe8ecef)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            dropdownColor: AppTheme.backgroundWhite,
                            value: dropdownvalue,
                            hint: Text(
                              " region ",
                            ),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items,
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }).toList(),
                            onChanged: (String newValue) {
                              print(reg);
                              setState(() {
                                reg = newValue;
                                dropdownvalue = newValue;
                                // query = newValue;
                              });
                              print(reg);
                            },
                          ),
                        )),*/
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            icon: SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  "assets/town.png",
                                  color: Color(0xffc16161),
                                )),
                            hintText: "ville",
                            labelText: "ville",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: ville,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            icon: SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  "assets/town.png",
                                  color: Color(0xffc16161),
                                )),
                            hintText: "ville arabe",
                            labelText: "ville arabe",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: ville_ar,
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            icon: SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  "assets/politic.png",
                                  color: Color(0xffc16161),
                                )),
                            hintText: "gouvernorat",
                            labelText: "gouvernorat",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: gouv,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            icon: SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  "assets/politic.png",
                                  color: Color(0xffc16161),
                                )),
                            hintText: "gouvernorat arabe",
                            labelText: "gouvernorat arabe",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: gouv_ar,
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.link,
                              color: Color(0xffc16161),
                            ),
                            hintText: "source ar",
                            labelText: "source ar",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: source_ar,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.link,
                              color: Color(0xffc16161),
                            ),
                            hintText: "source fr",
                            labelText: "source fr",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: source_fr,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff6fafd),
                        border: Border.all(color: Color(0xffe8ecef)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.link,
                              color: Color(0xffc16161),
                            ),
                            hintText: "source en",
                            labelText: "source en",
                            focusColor: Color(0xffc16161),
                            border: InputBorder.none),
                        controller: source_en,
                      ),
                    ),
                    _.isloading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : GestureDetector(
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Color(0xffc16161),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                'Confirmer',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onTap: () async {
                              if (_formKey.currentState.validate()) {
                                var temp = [];
                                for (var e in _.monumentUpdate) {
                                  temp.add(e.toJson());
                                  print(e.toJson());
                                }
                                if (widget.update) {
                                  await _.updateSite({
                                    'name_ar': name_ar.text,
                                    'name_fr': name_fr.text,
                                    'name_en': name_en.text,
                                    'source_ar': source_ar.text,
                                    'source_fr': source_fr.text,
                                    'source_en': source_en.text,
                                    'description_ar': desc_ar.text,
                                    'description_fr': desc_fr.text,
                                    'description_en': desc_en.text,
                                    'ville_ar': ville_ar.text,
                                    'ville': ville.text,
                                    'region': _.region,
                                    'gouvernorat_ar': gouv_ar.text,
                                    'gouvernorat': gouv.text,
                                    'horaire_hiver': time_hiver.text,
                                    'horaire_ete': time_ete.text,
                                    'horaire_ramadan': time_ramad.text,
                                    'patrimoine': checkedValue,
                                    'frais_resident': frais_res.text,
                                    'frais_etranger': frais_etr.text,
                                    'lat': lat.text,
                                    'long': long.text,
                                    'type': _.typesUpdate.join(";"),
                                    'epoque': _.epoUpdate.join(";"),
                                    'images': _.imagesUpdate.join(";"),
                                    'image360': _.images360Update.join(";"),
                                    'jour_ferm': _.joursUpdate.join(";"),
                                    "monument": temp,
                                    'commodite': _.commUpdate.join(";")
                                  }, _.detail.id);
                                } else {
                                  await _.postSite({
                                    'name_ar': name_ar.text,
                                    'name_fr': name_fr.text,
                                    'name_en': name_en.text,
                                    'source_ar': source_ar.text,
                                    'source_fr': source_fr.text,
                                    'source_en': source_en.text,
                                    'description_ar': desc_ar.text,
                                    'description_fr': desc_fr.text,
                                    'description_en': desc_en.text,
                                    'ville_ar': ville_ar.text,
                                    'ville': ville.text,
                                    'region': _.region,
                                    'gouvernorat_ar': gouv_ar.text,
                                    'gouvernorat': gouv.text,
                                    'horaire_hiver': time_hiver.text,
                                    'horaire_ete': time_ete.text,
                                    'horaire_ramadan': time_ramad.text,
                                    'patrimoine': checkedValue,
                                    'frais_resident': frais_res.text,
                                    'frais_etranger': frais_etr.text,
                                    'lat': lat.text,
                                    'long': long.text,
                                    'type': _.typesUpdate.join(";"),
                                    'epoque': _.epoUpdate.join(";"),
                                    'images': _.imagesUpdate.join(";"),
                                    'image360': _.images360Update.join(";"),
                                    'jour_ferm': _.joursUpdate.join(";"),
                                    "monument": temp,
                                    'commodite': _.commUpdate.join(";")
                                  });
                                }
                              }
                              /* _.addToFirebase(Event(
                      title_en: title_en.text,
                      title_fr: title_fr.text,
                      title_ar: title_ar.text,
                      desc_en: desc_en.text,
                      desc_fr: desc_fr.text,
                      desc_ar: desc_ar.text,
                      time: time.text,
                      organization: organization.text,
                      location_en: region_en.text,
                      location_fr: region_fr.text,
                      location_ar: region_ar.text,
                      image: _.uploadedFileURL,
                      date_deb: date));*/
                              /* Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage()));*/
                            },
                          ),
                  ]),
                )));
    });
  }

  /// get urls text-fields
  List<Widget> _getFriends(bool tour) {
    List<Widget> friendsTextFields = [];
    //print(list.length == 1 && list[0] != null);
    //print(list);

    for (int i = 0; i < (tour ? toursList.length : friendsList.length); i++) {
      friendsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: tour ? TourTextFields(i) : FriendTextFields(i)),
            // we need add button at last friends row
            _addRemoveButton(
                (tour
                    ? i == (toursList.length - 1)
                    : i == (friendsList.length - 1)),
                i,
                tour),
            SizedBox(
              width: 16,
            ),
          ],
        ),
      ));
    }

    return friendsTextFields;
  }

  Widget _addRemoveButton(bool add, int index, bool tour) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          tour ? toursList.insert(0, null) : friendsList.insert(0, null);
          var temp = tour
              ? placecontroller.images360Update
              : placecontroller.imagesUpdate;
          temp.add("https://drive.google.com/uc?export=view&id=" +
              (tour ? toursList[1] : friendsList[1]));
          setState(() {
            tour
                ? placecontroller.setImages360Update(temp)
                : placecontroller.setImagesUpdate(temp);
          });
        } else
          tour ? toursList.removeAt(index) : friendsList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Color(0xfff6fafd) : Colors.red,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xffe8ecef)),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: (add) ? Color(0xffc16161) : Colors.white,
        ),
      ),
    );
  }
}
