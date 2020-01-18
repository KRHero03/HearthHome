import 'dart:core';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TouristSaveData {
  String uid;
  String name;
  String govId;
  String country;
  String govIdUrl;
  String profilePicUrl;
  String gender;

  Future<void> saveData({
    @required String name,
    @required String govId,
    @required String country,
    @required String govIdUrl,
    @required String profilePicUrl,
    @required String phone,
    @required String gender,
  }) async {
    final url =
        'https://fhttps://hearthhome-60634.firebaseio.com/users/Tourist.json';

    try {
      var res = await http.post(url,
          body: json.encode({
            'Name': name,
            'Phone': phone,
            'Country': country,
            'ProfilePicture': profilePicUrl,
            'GovID': govId,
            'GovIDURL': govIdUrl,
            'Gender': gender,
          }));

      var data = json.decode(res.body);
      print(data);
    } catch (error) {
      print(error);
    }
  }
}