

import 'package:flutter/material.dart';
import 'package:hearthhome/models/enum.dart';
import 'package:hearthhome/widgets/circular_image_view.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
  
}

class HomeState extends State<Home>{
  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xff2893ff)),
          backgroundColor: Color(0xfff3f5ff),
          elevation: 1.0,
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircularImageView(
                w: 50,
                h: 50,
                imageLink: 'assets/icon/icon_round.png',
                imgSrc: ImageSourceENUM.Asset,
              ),
              Wrap(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    'HearthHome',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Standard',
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ])
            ],
          ),
        ),body:Text('Hello'));
  }
  
}