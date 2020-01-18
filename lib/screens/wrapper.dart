import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hearthhome/screens/splash_screen.dart';
import 'package:hearthhome/screens/split_screen.dart';
import 'package:provider/provider.dart';

import 'authenticate/authenticate.dart';

class Wrapper extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WrapperState();
  }
}

class WrapperState extends State<Wrapper> {
  bool exists;
  bool reloaded = false;
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    if (reloaded == false) {
      if (user != null) user.reload();
      reloaded = true;
    }
    if (user == null)
      return Authenticate();
    else {
      if (user.isEmailVerified) {
        if (exists == null) {
          FirebaseDatabase.instance
              .reference()
              .child('Users')
              .child(user.uid)
              .once()
              .then((DataSnapshot snapshot) {
            if (snapshot.value != null) {
              setState(() {
                exists = true;
              });
            } else {
              exists = false;
            }
          });
        }
        if (exists == null) {
          return SplashScreen();
        } else {
          if (exists == true) {
            return Container(
              child: Text('Hello'),
            );
          } else {
            return SplitScreen();
          }
        }
      } else {
        Fluttertoast.showToast(
            msg: "Please verify your Email Address!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 2,
            backgroundColor: Color(0xfff3f5ff),
            textColor: Theme.of(context).primaryColor,
            fontSize: 16.0);
        return Authenticate();
      }
    }
  }
}
