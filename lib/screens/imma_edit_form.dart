// @dart=2.9

import 'package:admin_toutn/core/model/imaa_patri.dart';
import 'package:admin_toutn/screens/widgets/textfield_immat_pics_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_carousel/carousel.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import '../app_theme.dart';
import '../core/controller/edit_immat_controller.dart';
import '../main.dart';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

class EditFormImmat extends StatefulWidget {
  final update;

  const EditFormImmat({Key key, this.update}) : super(key: key);

  @override
  EditFormImmatState createState() => EditFormImmatState();
}

class EditFormImmatState extends State<EditFormImmat> {
  final formController = Get.put(ImmatController());
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
  static List<String> urlsList = [];

  TextEditingController title_fr = TextEditingController(),
      title_en = TextEditingController(),
      title_ar = TextEditingController(),
      desc_fr = TextEditingController(),
      desc_en = TextEditingController(),
      desc_ar = TextEditingController(),
      source_fr = TextEditingController(),
      source_en = TextEditingController(),
      source_ar = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    title_ar = TextEditingController(
        text: widget.update ? formController.detail.name_ar : "");
    title_fr = TextEditingController(
        text: widget.update ? formController.detail.name_fr : "");
    title_en = TextEditingController(
        text: widget.update ? formController.detail.name_en : "");
    desc_en = TextEditingController(
        text: widget.update ? formController.detail.description_en : "");
    desc_ar = TextEditingController(
        text: widget.update ? formController.detail.description_ar : "");
    desc_fr = TextEditingController(
        text: widget.update ? formController.detail.description_fr : "");
    source_en = TextEditingController(
        text: widget.update ? formController.detail.source_en : "");
    source_ar = TextEditingController(
        text: widget.update ? formController.detail.source_ar : "");
    source_fr = TextEditingController(
        text: widget.update ? formController.detail.source_fr : "");
    super.initState();
  }

  void openFileExplorer() async {
    try {
      _paths = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['png', 'jpg', 'svg', 'jpeg']);
      // _path=_paths.files.single.path.toString();
      print("my paths are" + _paths.files.single.bytes.toString());
      uploadToFirebase();
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString() + e.message);
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
    Uint8List fileBytes = _paths.files.single.bytes;
    File decodedimgfile = await File(fileBytes, "image1.jpg");

    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('events/${_paths.files.single.name}');
    final uploadTask = await storageRef.putData(
        _paths.files.single.bytes,
        SettableMetadata(
          contentType: 'image/${_paths.files.single.extension}',
        ));
    _base64 = base64.encode(_paths.files.single.bytes);
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
      cancelText: 'annuler',
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
    return GetBuilder<ImmatController>(builder: (_) {
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
            'Ajouter le patrimoine immatériel',
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
              _.imagesUpdate.isNotEmpty
                  ? Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.grey[100],
                            spreadRadius: 2,
                            blurRadius: 5)
                      ], borderRadius: BorderRadius.circular(15)),
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 4),
                      child: Stack(
                        children: [
                          Carousel(
                              height: MediaQuery.of(context).size.height / 3,
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
                              activeIndicatorColor:
                                  AppTheme.backgroundWhite.withOpacity(0.8),
                              unActiveIndicatorColor:
                                  AppTheme.choice1.withOpacity(0.3),
                              axis: Axis.horizontal,
                              showArrow: true,
                              children: List.generate(
                                  _.imagesUpdate.length,
                                  (i) => Center(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: 10, left: 10, right: 10),
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey[100],
                                                    spreadRadius: 2,
                                                    blurRadius: 5)
                                              ],
                                              image: DecorationImage(
                                                  onError: (object, stack) {
                                                    print("error image" +
                                                        stack.toString());
                                                  },
                                                  image: NetworkImage(
                                                      _.imagesUpdate[i]),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Align(
                                              alignment: Alignment.topLeft,
                                              child: GestureDetector(
                                                onTap: () {
                                                  // TODO delete picture from list
                                                  var temp = _.imagesUpdate;
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
              urlsList.isNotEmpty
                  ? Container()
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            urlsList.add(null);
                            setState(() {});
                          },
                          child: Container(
                              width: 200,
                              height: 35,
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xfff6fafd),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Color(0xffe8ecef)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 30,
                                    color: Color(0xffc16161),
                                  ),
                                  Text(
                                    "Ajouter des images",
                                    style: TextStyle(color: Colors.black45),
                                  )
                                ],
                              )),
                        ),
                      ),
                    ),
              ..._getFriends(),
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
                      hintText: "Titre patrimonial immatériel en français",
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
                      hintText: "Titre patrimonial immatériel en anglais",
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
                      hintText: "Titre patrimonial immatériel en arabe",
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
                        hintText: "Description du patrimoine immatériel en français",
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
                        hintText: "Description du patrimoine immatériel en anglais",
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
                        hintText: "Description du patrimoine immatériel en arabe",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
                    controller: desc_ar,
                  )),

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
                          widget.update ? "Mettre à jour l'élément" : "ajouter un élément",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onTap: () async {
                        //await _.uploadFile(file);

                        if (widget.update) {
                          print(" I am in update");

                          await _.updateToFirebase(Immat(
                              name_en: title_en.text,
                              name_fr: title_fr.text,
                              name_ar: title_ar.text,
                              description_en: desc_en.text,
                              description_fr: desc_fr.text,
                              description_ar: desc_ar.text,
                              source_fr: source_fr.text,
                              source_ar: source_ar.text,
                              source_en: source_en.text,
                              id: _.detail.id,
                              images: _.imagesUpdate));
                        } else {
                          print(" I am in Add");
                          await _.addToFirebase(Immat(
                              name_en: title_en.text,
                              name_fr: title_fr.text,
                              name_ar: title_ar.text,
                              description_en: desc_en.text,
                              description_fr: desc_fr.text,
                              description_ar: desc_ar.text,
                              source_fr: source_fr.text,
                              source_ar: source_ar.text,
                              source_en: source_en.text,
                              images: _.imagesUpdate));
                        }
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

  /// get urls text-fields
  List<Widget> _getFriends() {
    List<Widget> friendsTextFields = [];
    //print(list.length == 1 && list[0] != null);
    //print(list);

    for (int i = 0; i < urlsList.length; i++) {
      friendsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: UrlTextFields(i)),
            // we need add button at last friends row
            _addRemoveButton(
              (i == (urlsList.length - 1)),
              i,
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
      ));
    }

    return friendsTextFields;
  }

  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          urlsList.insert(0, null);
          var temp = formController.imagesUpdate;
          temp.add(urlsList[1]);
          setState(() {
            formController.setImagesUpdate(temp);
          });
        } else
          urlsList.removeAt(index);
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
