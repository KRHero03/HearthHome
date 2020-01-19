import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:hearthhome/models/enum.dart';
import 'package:hearthhome/provider/auth.dart';
import 'package:hearthhome/widgets/alert/alert_dialog.dart';
import 'package:hearthhome/widgets/alert/confirm_dialog.dart';
import 'package:hearthhome/widgets/circular_image_view.dart';
import 'package:hearthhome/widgets/delayed_animation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class GuestScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GuestScreenState();
  }
}

class GuestScreenState extends State<GuestScreen> {
  FirebaseDatabase db = FirebaseDatabase.instance;
  bool isEmpty = true;
  @override
  void initState() {
    db.setPersistenceCacheSizeBytes(1000000);
    db.setPersistenceEnabled(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool deleting = false;
    String country, name, gender, govID, govIDURL, phone;
    Auth _auth = Provider.of<Auth>(context);
    db.reference().child('Guests').child(_auth.userId).once().then((snapshot) async {
      if (snapshot.value != null) {
        await db
            .reference()
            .child('Users')
            .child('Tourist')
            .child(snapshot.key)
            .once()
            .then((snap) {
            country = snap.value['Country'].toString();
            name = snap.value['Name'].toString();
            gender = snap.value['Gender'].toString();
            govID = snap.value['GovID'].toString();
            govIDURL = snap.value['GovIDURL'].toString();
            phone = snap.value['Phone'].toString();
            setState(() {
              isEmpty = false;
            });
          
        });
      }
    });
    _deleteGuest() async {
      setState(() {
        deleting = true;
      });
      await showDialog(
              context: context,
              builder: (ctx) => CustomConfirmDialog(
                  title: 'HearthHome Delete Guest',
                  message: 'Are you sure you want to delete your Guest?'))
          .then((onValue) async {
        if (onValue == ConfirmAction.YES) {
          await db.reference().child('Guests').child(_auth.userId).remove();
          await db
              .reference()
              .child('Users')
              .child('Host')
              .child(_auth.userId)
              .child('Available')
              .set('True');
          setState(() {
            isEmpty = true;
            deleting = false;
          });
          showDialog(
              context: context,
              builder: (ctx) => CustomAlertDialog(
                    message:
                        'HearthHome removed your current Guest!\nHope you enjoyed his company!',
                    title: 'HearthHome Delete Guest',
                  ));
        }
      });
    }
    print(isEmpty);
    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Color(0xff2893ff)),
            backgroundColor: Color(0xfff3f5ff),
            elevation: 1.0,
            title: new SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircularImageView(
                    w: 50,
                    h: 50,
                    imageLink: 'assets/icon/icon_round.png',
                    imgSrc: ImageSourceENUM.Asset,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      'HearthHome - Your Guest',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Standard',
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )),
        body: isEmpty
            ? Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'You have no Guests yet...',
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Standard',
                      color: Color(0xfff3f5ff),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ))
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DelayedAnimation(
                  delay: 300,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Standard',
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          gender,
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Standard',
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          phone,
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Standard',
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          country,
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Standard',
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          govID,
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Standard',
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                              height: 300,
                              width: 300,
                              child: Image(
                                image: AdvancedNetworkImage(
                                  govIDURL,
                                  useDiskCache: true,
                                  cacheRule: CacheRule(
                                      maxAge: const Duration(days: 7)),
                                ),
                                fit: BoxFit.cover,
                              ))),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: MaterialButton(
                          onPressed: deleting ? null : _deleteGuest,
                          child: deleting
                              ? CircularProgressIndicator()
                              : SingleChildScrollView(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                      Icon(MdiIcons.delete,
                                          color: Color(0xfff3f5ff)),
                                      Text(
                                        'DELETE GUEST',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Standard',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ])),
                          color: Theme.of(context).accentColor,
                          elevation: 0,
                          minWidth: 400,
                          height: 50,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                )));
  }
}
