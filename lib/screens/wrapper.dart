
import 'package:flutter/material.dart';
import 'package:hearthhome/provider/auth.dart';
import 'package:hearthhome/screens/auth_screen.dart';
import 'package:hearthhome/screens/splash_screen.dart';
import 'package:hearthhome/screens/split_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home.dart';

class Wrapper extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WrapperState();
  }
}

class WrapperState extends State<Wrapper> {
  int exists = 0;
  bool reloaded = false;
  @override
  Widget build(BuildContext context) {
    Auth _auth = Provider.of<Auth>(context);
    if (_auth.isAuth) {
      if (exists == null) {
        FirebaseDatabase.instance
            .reference()
            .child('Users')
            .child(_auth.userId)
            .once()
            .then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            setState(() {
              exists = 3;
            });
          } else {
            setState(() {
              exists = 2;
            });
          }
        });
      }
    } else {
      _auth.tryAutoLogin().then((onValue) {        
        if (onValue == true) {
          FirebaseDatabase.instance
              .reference()
              .child('Users')
              .child(_auth.userId)
              .once()
              .then((DataSnapshot snapshot) {
            if (snapshot.value != null) {
              setState(() {
                exists = 3;
              });
            } else {
              setState(() {
                exists = 2;
              });
            }
          });
        } else {
          setState(() {
            exists = 1;
          });
        }
      });
    }

    if (exists == 0) {
      return SplashScreen();
    } else if (exists == 1) {
      return AuthScreen();
    } else if (exists == 2) {
      return SplitScreen();
    } else {
      return Home();
    }
  }
}
