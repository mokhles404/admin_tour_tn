// @dart=2.9
import 'dart:convert';
import 'dart:html';

//import 'dart:io';
import 'dart:typed_data';
import 'package:admin_toutn/core/controller/form_controller.dart';
import 'package:admin_toutn/core/model/about.dart';
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
import '../core/controller/about_us_controller.dart';
import '../main.dart';
import 'dashboard.dart';

class AboutFormScreen extends StatefulWidget {
  _AboutFormScreenState createState() => _AboutFormScreenState();
}

class _AboutFormScreenState extends State<AboutFormScreen> {
  final aboutController = Get.put(AboutUsController());

  String title_fr, title_en, title_ar, desc_fr, desc_en, desc_ar;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetBuilder<AboutUsController>(builder: (_) {
      title_en = _.object.name_en;
      title_fr = _.object.name_fr;
      title_ar = _.object.name_ar;
      desc_ar = _.object.description_ar;
      desc_en = _.object.description_en;
      desc_fr = _.object.description_fr;
      return Scaffold(
        backgroundColor: Color(0xfff9f9f9),
        appBar: AppBar(
          backgroundColor: Color(0xfff9f9f9),
          elevation: 0.0,
          centerTitle: true,

          title: Text(
            'mettre à jour à propos de nous',
            style: TextStyle(color: Color(0xffc16161)),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 100),
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
                  initialValue: title_fr,
                  onChanged: (val){
                    title_fr=val;
                  },
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.event_available,
                        color: Color(0xffc16161),
                      ),
                      hintText: "Amvppc -French",
                      focusColor: Color(0xffc16161),
                      border: InputBorder.none),
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
                  initialValue: title_en,

                  onChanged: (val) {
                    title_en=val;
                  },
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.event_available,
                        color: Color(0xffc16161),
                      ),
                      hintText: "Amvppc -English",
                      focusColor: Color(0xffc16161),
                      border: InputBorder.none),
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
                  initialValue: title_ar,

                  onChanged: (val) {
                    title_ar=val;
                  },
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.event_available,
                        color: Color(0xffc16161),
                      ),
                      hintText: "Amvppc -Arabic",
                      focusColor: Color(0xffc16161),
                      border: InputBorder.none),
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
                    initialValue: desc_fr,

                    onChanged: (val) {
                      desc_fr=val;
                    },
                    maxLines: 3,
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.description,
                          color: Color(0xffc16161),
                        ),
                        hintText: "Description-French",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
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
                    initialValue: desc_en,

                    onChanged: (val) {
                      desc_en=val;
                    },
                    maxLines: 3,
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.description,
                          color: Color(0xffc16161),
                        ),
                        hintText: "Description-English",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
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
                    initialValue: desc_ar,
                    onChanged: (val) {
                      desc_ar=val;
                    },
                    maxLines: 3,
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.description,
                          color: Color(0xffc16161),
                        ),
                        hintText: "Description-Arabic",
                        focusColor: Color(0xffc16161),
                        border: InputBorder.none),
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
                            EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width /4, vertical: 10),
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
                        //await _.uploadFile(file);
                        Map<String, dynamic> data = {
                          "name_en": title_en,
                          "name_fr": title_fr,
                          "name_ar": title_ar,
                          "description_en": desc_en,
                          "description_fr": desc_fr,
                          "description_ar": desc_ar
                        };
                       await  _.updateAbout(data);
                        /* Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage()));*/
                      },
                    ),
            ],
          ),
        ),
      );
    });
  }
}
