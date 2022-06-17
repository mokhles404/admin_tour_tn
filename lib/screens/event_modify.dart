// @dart=2.9

import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:admin_toutn/core/controller/form_controller.dart';
import 'package:admin_toutn/core/model/event.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import 'dashboard.dart';

class FormEventModifyScreen extends StatefulWidget {
  final Event event;

  const FormEventModifyScreen({Key key, this.event}) : super(key: key);

  _FormEventModifyScreen createState() => _FormEventModifyScreen();
}

class _FormEventModifyScreen extends State<FormEventModifyScreen> {
  final formController = Get.put(FormController());

  List<File> _images = [];
  File _image;
  DateTime selectedDate = DateTime.now();
  String time="",
      title_fr = "",
      title_en = "",
      title_ar = "",
      desc_fr = "",
      desc_en = "",
      desc_ar = "",
      place_fr = "",
      place_en = "",
      place_ar = "",
      organization = "",
      region_fr = "",
      region_en = "",
      region_ar = "",
      date_deb = "",
      date_fin = "";
  FilePickerResult _paths;
  String _base64;

  void openFileExplorer() async {
    try {
      _paths = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions:['png', 'jpg', 'svg', 'jpeg'] );
      // _path=_paths.files.single.path.toString();
      print("my paths are"+_paths.files.single.bytes.toString());
      uploadToFirebase();
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString()+e.message);
    }
    if (!mounted) return;
  }

  uploadToFirebase() {
    /*String fileName = _path.split('/').last;
      String filePath = _path;*/
    upload();

  }

  upload() async {
    // _extension = fileName.toString().split('.').last;
    Uint8List fileBytes =_paths.files.single.bytes;
    File decodedimgfile = await File(fileBytes,"image1.jpg");

    Reference storageRef =
    FirebaseStorage.instance.ref().child('events/${_paths.files.single.name}');
    final  uploadTask = await storageRef.putData(
        _paths.files.single.bytes,
        SettableMetadata(
          contentType: 'image/${_paths.files.single.extension}',)
    );
    _base64=base64.encode(_paths.files.single.bytes);
    await storageRef.getDownloadURL().then((fileURL) {
      print(fileURL);
      formController.setUploadUrl(fileURL);
    });
    /* setState(() {
      _tasks.add(uploadTask.);
    });*/
  }
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
      confirmText: 'Confirmer',
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

  /*Future getImage(bool gallery) async {
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
  }*/

  @override
  Widget build(BuildContext context) {
    // date_fin = widget.event.date_fin;
    final datepickerbtn = GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          width: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: Icon(Icons.date_range),
            title: Text("sélectionner une date"),
          )),
    );
    // TODO: implement build
    return GetBuilder<FormController>(initState: (state) {
      time = widget.event.time;
      title_en = widget.event.title_en;
      title_fr = widget.event.title_fr;
      title_ar = widget.event.title_ar;
      place_ar = widget.event.location_ar;
      place_en = widget.event.location_en;
      place_fr = widget.event.location_fr;
      desc_ar = widget.event.desc_ar;
      desc_fr = widget.event.desc_fr;
      desc_en = widget.event.desc_en;
      organization = widget.event.organization;
      region_fr = widget.event.location_fr;
      region_en = widget.event.location_en;
      region_ar = widget.event.location_ar;
      date_deb = widget.event.date_deb;
    }, builder: (_) {
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
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Edit événement ',
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
                child: TextFormField(
                  onChanged: (val) {
                    print(val);
                    title_fr = val;
                    print(title_fr);
                  },
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.event_available,
                        color: Color(0xffc16161),
                      ),
                      hintText: "Titre de l’événement en français",
                      focusColor: Color(0xffc16161),
                      border: InputBorder.none),
                  initialValue: title_fr,
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
                child: TextFormField(
                  onChanged: (val) {
                    title_en = val;
                  },
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.event_available,
                        color: Color(0xffc16161),
                      ),
                      hintText: "Titre de l’événement en anglais",
                      focusColor: Color(0xffc16161),
                      border: InputBorder.none),
                  initialValue: title_en,
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
                child: TextFormField(
                  onChanged: (val) {
                    title_ar = val;
                  },
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.event_available,
                        color: Color(0xffc16161),
                      ),
                      hintText: "Titre de l’événement en arabe",
                      focusColor: Color(0xffc16161),
                      border: InputBorder.none),
                  initialValue: title_ar,
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
                  child: TextFormField(
                    maxLines: 3,
                    onChanged: (val) {
                      desc_fr = val;
                    },
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.description,
                          color: Color(0xffc16161),
                        ),
                        hintText: "Description de l’événement en français",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
                    initialValue: desc_fr,
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xfff6fafd),
                    border: Border.all(color: Color(0xffe8ecef)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    maxLines: 3,
                    onChanged: (val) {
                      desc_en = val;
                    },
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.description,
                          color: Color(0xffc16161),
                        ),
                        hintText: "Description de l’événement en anglais",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
                    initialValue: desc_en,
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xfff6fafd),
                    border: Border.all(color: Color(0xffe8ecef)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    maxLines: 3,
                    onChanged: (val) {
                      desc_ar = val;
                    },
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.description,
                          color: Color(0xffc16161),
                        ),
                        hintText: "Description de l’événement en arabe",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
                    initialValue: desc_ar,
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xfff6fafd),
                    border: Border.all(color: Color(0xffe8ecef)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    onChanged: (val) {
                      organization = val;
                    },
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.group,
                          color: Color(0xffc16161),
                        ),
                        hintText: "Organisation",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
                    initialValue: organization,
                  )),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xfff6fafd),
                  border: Border.all(color: Color(0xffe8ecef)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  onChanged: (val) {
                    print(val);
                    time = val;
                    print(time);
                  },
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.timelapse,
                        color: Color(0xffc16161),
                      ),
                      hintText: "Heure de l'événement de quand à quand",
                      focusColor: Color(0xffc16161),
                      border: InputBorder.none),
                  initialValue: time,
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
                  child: TextFormField(
                    onChanged: (val) {
                      region_fr = val;
                    },
                    decoration: InputDecoration(
                        icon: SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.asset(
                              "assets/town.png",
                              color: Color(0xffc16161),
                            )),
                        hintText: "Lieu de l'événement en français",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
                    initialValue: region_fr,
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xfff6fafd),
                    border: Border.all(color: Color(0xffe8ecef)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    onChanged: (val) {
                      region_en = val;
                    },
                    decoration: InputDecoration(
                        icon: SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.asset(
                              "assets/town.png",
                              color: Color(0xffc16161),
                            )),
                        hintText: "Lieu de l'événement en anglais",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
                    initialValue: region_en,
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xfff6fafd),
                    border: Border.all(color: Color(0xffe8ecef)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    onChanged: (val) {
                      region_ar = val;
                    },
                    decoration: InputDecoration(
                        icon: SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.asset(
                              "assets/town.png",
                              color: Color(0xffc16161),
                            )),
                        hintText: "Lieu de l'événement en arabe",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
                    initialValue: region_ar,
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xfff6fafd),
                    border: Border.all(color: Color(0xffe8ecef)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    onChanged: (val) {
                      date_deb = val;
                    },
                    onTap: () {
                      _selectDate(context);
                      date_deb = selectedDate.toString();
                    },
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.date_range,
                          color: Color(0xffc16161),
                        ),
                        hintText: "Date de l'événement",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
                    initialValue: date_deb,
                  )),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xfff6fafd),
                  border: Border.all(color: Color(0xffe8ecef)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _paths==null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.network(widget.event.image),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Color(0xffc16161),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                'choisissez Fichier',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onTap: () async {
                              openFileExplorer();

                              // getImage(true);
                              // await _.uploadFile(_image);
                            },
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.network(_.uploadedFileURL),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Color(0xffc16161),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                'choisissez Fichier',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onTap: () async {
                              openFileExplorer();

                              //  getImage(true);
                              // await _.uploadFile(_image);
                            },
                          ),
                        ],
                      ),
              ),
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
                          'Edit événement ',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onTap: () async {
                        if (_image != null) {
                        //  await _.uploadFile(_image);
                        }
                        print(widget.event.image);
                        var date =
                            DateFormat('yyyy-MM-dd').format(selectedDate);
                        print({
                          "title_ar": title_ar,
                          "title_fr": title_fr,
                          "title_en": title_en,
                          "desc_ar": desc_ar,
                          "desc_fr": desc_fr,
                          "desc_en": desc_en,
                          "organization": organization,
                          "location_ar": region_ar,
                          "location_fr": region_fr,
                          "location_en": region_en,
                          "date_fin": date_fin,
                          "date_deb": date_deb,
                          "image": widget.event.image,
                        });
                        await _.updateToFirebase(Event(
                            id: widget.event.id,
                            title_en: title_en,
                            title_fr: title_fr,
                            title_ar: title_ar,
                            time: time,
                            desc_en: desc_en,
                            desc_fr: desc_fr,
                            desc_ar: desc_ar,
                            organization: organization,
                            location_en: region_en,
                            location_fr: region_fr,
                            location_ar: region_ar,
                            image: _paths != null
                                ? _.uploadedFileURL
                                : widget.event.image,
                            date_deb: date));
                       /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()));*/
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
