// @dart=2.9

import 'package:admin_toutn/screens/add_one_site.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendTextFields extends StatefulWidget {
  final int index;

  FriendTextFields(this.index);

  @override
  _FriendTextFieldsState createState() => _FriendTextFieldsState();
}

class _FriendTextFieldsState extends State<FriendTextFields> {
  TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text = AddOneSiteState.friendsList[widget.index] ?? '';
    });
    return Container(
      // padding: EdgeInsets.all(10),
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
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Text(
              "https://drive.google.com/uc?export=view&id=",
              style: TextStyle(color: Colors.black45),
            ),
          ),
          TextFormField(
            validator: (v) {
              if (v.trim().isEmpty) return 'Please enter something';
              return null;
            },
            onChanged: (v) => AddOneSiteState.friendsList[widget.index] = v,
            decoration: InputDecoration(
                hintText: "ID picture",
                focusColor: Color(0xffc16161),
                border: InputBorder.none),
            controller: _nameController,
          )
        ],
      ),
    );
  }
}
