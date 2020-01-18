import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        color: Theme.of(context).primaryColor,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Image(
              image: AssetImage('assets/icon/icon_round.png'),
            ),
            Padding(
                padding: EdgeInsets.all(5),
                child: Text('HearthHome',
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: 'Standard',
                      color: Color(0xfff3f5ff),
                    ),
                    textAlign: TextAlign.center,)),
            Padding(
                padding: EdgeInsets.all(5),
                child: Text('Experience your home abroad...',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Standard',
                      color: Color(0xfff3f5ff),
                    ),
                    textAlign: TextAlign.center,)),
            Padding(
                padding: EdgeInsets.only(top: 30, bottom: 5, left: 5, right: 5),
                child: Text('Please wait while we load HearthHome for you...',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Standard',
                      color: Color(0xfff3f5ff),
                    ),
                    textAlign: TextAlign.center,
                    )),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ))
    );
  }
}

