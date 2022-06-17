// @dart=2.9

import 'dart:io';
import 'package:admin_toutn/core/controller/form_controller.dart';
import 'package:admin_toutn/core/model/event.dart';
import 'package:admin_toutn/core/model/notification.dart' as notif;
import 'package:admin_toutn/main.dart';
import 'package:admin_toutn/screens/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotifScreen extends StatefulWidget {
  _NotifScreenState createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotifScreen> {
  List<File> _images = [];
  File _image;
  DateTime selectedDate = DateTime.now();

  final TextEditingController title = TextEditingController(),
      desc = TextEditingController(),
      type = TextEditingController(),
      date = TextEditingController();

  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(Duration(days: 10))))) {
      return true;
    }
    return false;
  }

  _selectDate(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context);
    }
  }

  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != selectedDate)
                  setState(() {
                    selectedDate = picked;
                  });
              },
              initialDateTime: selectedDate,
              minimumYear: 2000,
              maximumYear: 2030,
            ),
          );
        });
  }

  buildMaterialDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: DatePickerMode.day,
      // selectableDayPredicate: _decideWhichDayToEnable,
      helpText: 'Choisir une date ',
      cancelText: 'Annuler',
      confirmText: 'confirmer',
      errorFormatText: 'Error syntax',
      errorInvalidText: 'La date n’est pas valide.',
      fieldLabelText: 'Choisir une date',
      fieldHintText: 'JJ/MM/YYYY',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }

    setState(() {
      if (pickedFile != null) {
        _images.add(File(pickedFile.path));
        _image = File(pickedFile.path); // Use if you only need a single picture
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final datepickerbtn = GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          width: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: Icon(Icons.date_range),
            title: Text("Sélectionner une date"),
          )),
    );
    // TODO: implement build
    return GetBuilder<FormController>(builder: (_) {
      return Scaffold(
        backgroundColor: Color(0xfff9f9f9),
        appBar: AppBar(
          backgroundColor: Color(0xfff9f9f9),
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: (){
              Navigator.pop(context);

            },
          ),
          title: Text(
            'Envoyer une notification',
            style: TextStyle(color: Color(0xffc16161)),
          ),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              /*Text('Selected Image'),
              _image != null
                  ? Image.file(
                      _image,
                      height: 150,
                    )
                  : Container(height: 150),*/
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xfff6fafd),
                  border: Border.all(color: Color(0xffe8ecef)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.notifications_active,
                        color: Color(0xffc16161),
                      ),
                      hintText: "Titre de la notification",
                      focusColor: Color(0xffc16161),
                      border: InputBorder.none),
                  controller: title,
                ),
              ),

              Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xfff6fafd),
                    border: Border.all(color: Color(0xffe8ecef)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.description,
                          color: Color(0xffc16161),
                        ),

                        hintText: "Description de la notification",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
                    maxLines: 3,
                    controller: desc,
                  )),

              /*Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xfff6fafd),
                    border: Border.all(color: Color(0xffe8ecef)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.filter_alt_outlined,
                          color: Color(0xffc16161),
                        ),
                        hintText: "Type",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
                    controller: type,
                  )),*/
             /* Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xfff6fafd),
                    border: Border.all(color: Color(0xffe8ecef)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    onTap: () {
                      _selectDate(context);
                      date.text = selectedDate.toString();
                    },
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.date_range,
                          color: Color(0xffc16161),
                        ),
                        hintText: "Notification date",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
                    controller: date,
                  )),*/

              //datepickerbtn,
              _.isloading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        decoration: BoxDecoration(
                            color: Color(0xffc16161),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'Envoyer une notification',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onTap: () async {
                        var date =
                            DateFormat('yyyy-MM-dd').format(DateTime.now());
                        var news=notif.Notification(
                            title: title.text,
                            description: desc.text,
                          date: date,
                          type: "news"
                        );
                        await _.sendNotification(news);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyHomePage()));
                      },
                    ),

              /*_image != null
                  ? RaisedButton(
                      child: Text('Upload File'),
                      onPressed: () {
                        _.uploadFile(_image);
                      },
                      color: Colors.cyan,
                    )
                  : Container(),
              _image != null
                  ? RaisedButton(
                      child: Text('Clear Selection'),
                      onPressed: null,
                    )
                  : Container(),
              Text('Uploaded Image'),
              _.uploadedFileURL != null
                  ? Image.network(
                      _.uploadedFileURL,
                      height: 150,
                    )
                  : Container(),*/
            ],
          ),
        ),
      );
    });
    /*return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).size.height / 3,
            child: Image.file(_images[0]),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3,
            child: RawMaterialButton(
              fillColor: Theme.of(context).accentColor,
              child: Icon(
                Icons.add_photo_alternate_rounded,
                color: Colors.white,
              ),
              elevation: 8,
              onPressed: () {
                getImage(true);
              },
              padding: EdgeInsets.all(15),
              shape: CircleBorder(),
            ),
          )
        ],
      ),
    );*/
  }
}
