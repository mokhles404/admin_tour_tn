// @dart=2.9

import 'package:flutter/material.dart';
import 'package:admin_toutn/app_theme.dart';

class EmptyState extends StatelessWidget {
  final String title, message;
  EmptyState({this.title, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
         // height: 200,
          width: 200,
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 150,
                  width: 150,
                  child:  Image.asset(
                    'assets/box.png',
                    fit: BoxFit.contain,
                    color: AppTheme.choice1,
                  )),
              SizedBox(height: 20,),

              Text( title+"\n"+message,textAlign: TextAlign.center,)
            ],
          )),
    );
  }
}
