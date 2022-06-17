
// @dart=2.9
import 'dart:convert';
import 'dart:html';
//import 'dart:io';
import 'dart:typed_data';
import 'package:admin_toutn/core/controller/form_controller.dart';
import 'package:admin_toutn/core/model/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import 'dashboard.dart';

class FormEventScreen extends StatefulWidget {
  _FormEventScreenState createState() => _FormEventScreenState();
}

class _FormEventScreenState extends State<FormEventScreen> {
  final formController = Get.put(FormController());
  List<File> _images = [];
  File _image;
  DateTime selectedDate = DateTime.now();
  final _pickedImages = <Image>[];
  String _imageInfo = '';
  String _base64;
  FilePickerResult _paths;
  String _extension;
  FileType _pickType;
  bool _multiPick = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<UploadTask> _tasks = <UploadTask>[];

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

  Future<void> _pickImage() async {
    final fromPicker = await ImagePickerWeb.getImageAsWidget();
    if (fromPicker != null) {
      setState(() {
        _pickedImages.clear();
        _pickedImages.add(fromPicker);
      });
    }
  }

  final TextEditingController title_fr = TextEditingController(),
      title_en = TextEditingController(),
      title_ar = TextEditingController(),
      desc_fr = TextEditingController(),
      desc_en = TextEditingController(),
      desc_ar = TextEditingController(),
      place_fr = TextEditingController(),
      place_en = TextEditingController(),
      place_ar = TextEditingController(),
      time = TextEditingController(),
      organization = TextEditingController(),
      region_fr = TextEditingController(),
      region_en = TextEditingController(),
      region_ar = TextEditingController(),
      date_deb = TextEditingController(),
      date_fin = TextEditingController();

  /*void uploadImage({@required Function(File file) onSelected}) {
    InputElement uploadInput = FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    });
  }

  void uploadToStorage() {
    uploadImage(
      onSelected: (file) async {
        final reader = FileReader();
        reader.readAsDataUrl(file);
        io.File _itemPicIoFile;
        reader.onLoad.first.then((res) {
          final encoded = reader.result as String;
          final imageBase64 = encoded.replaceFirst(
              RegExp(r'data:image/[^;]+;base64,'),
              ''); // this is to remove some non necessary stuff
          _itemPicIoFile = io.File.fromRawPath(base64Decode(imageBase64));
        }).catchError((error) => print("${error.message}"));
        var storageReference =
            FirebaseStorage.instance.ref().child("events/${title_en.text}");
        var uploadTask = await storageReference.putFile(_itemPicIoFile);
        await uploadTask.onComplete;
        print('File Uploaded');
        await storageReference.getDownloadURL().then((fileURL) {
          formController.setUploadUrl(fileURL);
        });
      },
    );
  }*/*/

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

    /*setState(() {
      if (pickedFile != null) {
        _images.add(File(pickedFile.path));
        _image = File(pickedFile.path); // Use if you only need a single picture
      } else {
        print('No image selected.');
      }
    });*/
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
            title: Text("sélectionner une date"),
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
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Ajouter un évènement',
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
                        Icons.event_available,
                        color: Color(0xffc16161),
                      ),
                      hintText: "Titre de l’événement en français",
                      focusColor: Color(0xffc16161),
                      border: InputBorder.none),
                  controller: title_fr,
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
                        Icons.event_available,
                        color: Color(0xffc16161),
                      ),
                      hintText: "Titre de l’événement en anglais",
                      focusColor: Color(0xffc16161),
                      border: InputBorder.none),
                  controller: title_en,
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
                        Icons.event_available,
                        color: Color(0xffc16161),
                      ),
                      hintText: "Titre de l’événement en arabe",
                      focusColor: Color(0xffc16161),
                      border: InputBorder.none),
                  controller: title_ar,
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
                    maxLines: 3,
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.description,
                          color: Color(0xffc16161),
                        ),
                        hintText: "Description de l’événement en français",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
                    controller: desc_fr,
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xfff6fafd),
                    border: Border.all(color: Color(0xffe8ecef)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.description,
                          color: Color(0xffc16161),
                        ),
                        hintText: "Description de l’événement en anglais",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
                    controller: desc_en,
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xfff6fafd),
                    border: Border.all(color: Color(0xffe8ecef)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.description,
                          color: Color(0xffc16161),
                        ),
                        hintText: "Description de l’événement en arabe",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
                    controller: desc_ar,
                  )),
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
                          Icons.group,
                          color: Color(0xffc16161),
                        ),
                        hintText: "Organisation",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
                    controller: organization,
                  )),
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
                          Icons.timelapse,
                          color: Color(0xffc16161),
                        ),
                        hintText: "Heure de l'événement de quand à quand",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
                    controller: time,
                  )),
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
                    controller: region_fr,
                  )),
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
                    controller: region_en,
                  )),
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
                    controller: region_ar,
                  )),
              Container(
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
                      date_deb.text = selectedDate.toString();
                    },
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.date_range,
                          color: Color(0xffc16161),
                        ),
                        hintText: "Date de l'événement",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
                    controller: date_deb,
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
                    ? Center(
                        child: GestureDetector(
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
                            // getImage(true);
                            openFileExplorer();

                            // await _.uploadFile(_image);
                            //uploadToStorage();
                          },
                        ),
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
                              //getImage(true);
                              openFileExplorer();
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
                        //await _.uploadFile(file);
                        var date =
                            DateFormat('yyyy-MM-dd').format(selectedDate);
                        _.addToFirebase(Event(
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
                            date_deb: date));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()));
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
