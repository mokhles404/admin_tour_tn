// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../imma_edit_form.dart';

class UrlTextFields extends StatefulWidget {
  final int index;

  UrlTextFields(this.index);

  @override
  _UrlTextFieldssState createState() => _UrlTextFieldssState();
}

class _UrlTextFieldssState extends State<UrlTextFields> {
  TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _urlController.text = EditFormImmatState.urlsList[widget.index] ?? '';
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
      child: TextFormField(
        validator: (v) {
          if (v.trim().isEmpty) return 'Veuillez entrer quelque chose';
          return null;
        },
        onChanged: (v) => EditFormImmatState.urlsList[widget.index] = v,
        decoration: InputDecoration(
            hintText: "image URL",
            focusColor: Color(0xffc16161),
            border: InputBorder.none),
        controller: _urlController,
      )
    );
  }
}
