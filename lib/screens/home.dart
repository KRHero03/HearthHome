import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';

import '../models/enum.dart';
import '../widgets/circular_image_view.dart';

class HomeData {
  bool submitting = false;

  double latitude, longitude;
  String name,
      address,
      countryName,
      phone,
      pincode,
      govID,
      govIDURL,
      adultMale,
      adultFemale,
      childrenMale,
      childrenFemale;

  HomeData(
      {this.name,
      this.address,
      this.phone,
      this.pincode,
      this.govIDURL,
      this.adultMale,
      this.adultFemale,
      this.childrenMale,
      this.childrenFemale});
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<HomeData> data = [];
  var _isloading = true;

  FirebaseDatabase db = FirebaseDatabase.instance;
  void initState() {
    db.reference().child('Users').child('Host').once().then((snap) {
      print(snap.value);
      //   snap.value.map((key, value) {

      // data.add(HomeData(
      //   name: value['Name'],
      //   address: value['Address']['Value'],
      //   childrenFemale: value['Household']['ChildrenFemale'],
      //   childrenMale: value['Household']['ChildrenMale'],
      //   adultFemale: value['Household']['AdultFemale'],
      //   adultMale: value['Household']['AdultMale'],
      //)
      //);
      //     });
      setState(() {
        _isloading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isloading) print(data);
    return Scaffold(
        appBar: AppBar(
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
        ),
        body: WillPopScope(
          onWillPop: () async {
            Future.value(
                false); //return a `Future` with false value so this route cant be popped or closed.
          },
          child: _isloading
              ? Center(child: CircularProgressIndicator())
              : FlatButton(
                  child: Text('logout'),
                  onPressed: () {
                    Provider.of<Auth>(context, listen: false).logOut();
                  },
                ),
          // : ListView.builder(
          //     itemCount: data.length,
          //     itemBuilder: (ctx, i) {
          //       return Container(

          //       );
          //     },
          //   ),
        ));
  }
}