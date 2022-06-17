// @dart=2.9

import 'package:admin_toutn/app_theme.dart';
import 'package:admin_toutn/core/model/monument.dart';
import 'package:flutter/material.dart';

typedef OnDelete();

class MonumentForm extends StatefulWidget {
  final index;
final name_ar, url_drive, name_fr, name_en, lat, long;
  final state = _MonumentFormState();
  final OnDelete onDelete;
  MonumentForm({Key key, this.index, this.onDelete, this.name_ar, this.url_drive, this.name_fr, this.name_en, this.lat, this.long}) : super(key: key);

  @override
  _MonumentFormState createState() => state;

  bool isValid() => state.validate();
}

class _MonumentFormState extends State<MonumentForm> {
  final form = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(16),
      child: Material(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8),
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: AppTheme.choice1,
                width: MediaQuery.of(context).size.width,
                child: ListTile(
                  leading: Icon(Icons.account_balance,color: AppTheme.backgroundWhite),
                  title: Text('Monument ${widget.index}',style: TextStyle(color: AppTheme.backgroundWhite),),
                  trailing: IconButton(
                    icon: Icon(Icons.delete,color: AppTheme.backgroundWhite),
                    onPressed: widget.onDelete,
                  ),
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xfff6fafd),
                  border: Border.all(color: Color(0xffe8ecef)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: widget.name_fr,

                  decoration: InputDecoration(
                    border: InputBorder.none,
                   // labelText: 'name in french',
                    hintText: 'Enter name in french',
                    icon: Icon(Icons.title),
                    isDense: true,
                  ),
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xfff6fafd),
                  border: Border.all(color: Color(0xffe8ecef)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: widget.name_en,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    //labelText: 'name in english',
                    hintText: 'Enter name in english',
                    icon: Icon(Icons.title),
                    isDense: true,
                  ),
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xfff6fafd),
                  border: Border.all(color: Color(0xffe8ecef)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: widget.name_ar,

                  decoration: InputDecoration(
                    border: InputBorder.none,
                    //labelText: 'name in arabic',
                    hintText: 'Enter name in arabic',
                    icon: Icon(Icons.title),
                    isDense: true,
                  ),
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xfff6fafd),
                  border: Border.all(color: Color(0xffe8ecef)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: widget.lat,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    //labelText: 'Latitude',
                    hintText: 'Enter latitude',
                    icon: Icon(Icons.location_on),
                    isDense: true,
                  ),
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xfff6fafd),
                  border: Border.all(color: Color(0xffe8ecef)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: widget.long,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                   // labelText: 'Longitude',
                    hintText: 'Enter Longitude',
                    icon: Icon(Icons.location_on),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 24),
                  child: Container(
                    // padding: EdgeInsets.all(10),
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xfff6fafd),
                      border: Border.all(color: Color(0xffe8ecef)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                          child: Text(
                            "https://drive.google.com/uc?export=view&id=",
                            style: TextStyle(color: Colors.black45),
                          ),
                        ),
                        TextFormField(
                          controller: widget.url_drive,
                          decoration: InputDecoration(
                              hintText: "ID picture",
                              focusColor: Color(0xffc16161),
                              border: InputBorder.none),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  ///form validator
  bool validate() {
    var valid = form.currentState.validate();
    if (valid) form.currentState.save();
    return valid;
  }
}
