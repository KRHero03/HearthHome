import 'dart:core';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import '../provider/auth.dart';

class TouristSaveData {
  String uid;
  String name;
  String govId;
  String country;
  String govIdUrl;
  String profilePicUrl;
  String gender;
  FirebaseDatabase db = FirebaseDatabase.instance;

  Future<void> saveData(
      {@required String name,
      @required String govId,
      @required String country,
      @required String govIdUrl,
      @required String profilePicUrl,
      @required String phone,
      @required String gender,
      @required String userID}) async {
    DatabaseReference dbRef =
        db.reference().child('Users').child('Tourist').child(userID);
    dbRef.set({
      'Name': name,
      'Phone': phone,
      'Country': country,
      'ProfilePicture': profilePicUrl,
      'GovID': govId,
      'GovIDURL': govIdUrl,
      'Gender': gender,
    }).then((res) {
      print('ok Data save');
      this.country = country;
      this.gender = gender;
      this.govId = uid;
      this.govIdUrl = govIdUrl;
      this.name = name;
      this.uid = Auth().userId;
      this.profilePicUrl = profilePicUrl;
    }).catchError((onError) {
      print(onError);
    });
  }
}