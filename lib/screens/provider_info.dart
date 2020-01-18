

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProviderInfo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ProviderInfoState();
  }

  
}

class ProviderInfoState extends State<ProviderInfo>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child: Column(children: <Widget>[
           Padding(
                padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                child: TextFormField(
                  controller:null ,
                  style: TextStyle(
                      color: Color(0xff4564e5), fontFamily: 'Standard'),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      prefixIcon: Icon(
                        MdiIcons.email,
                        color: Color(0xff4564e5),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Standard',
                        color: Color(0xff4564e5),
                      )),
                ),
              ),
        ],),
      )

    );
  }
  
}