import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:hearthhome/agora/src/pages/call.dart';
import 'package:hearthhome/widgets/alert/alert_dialog.dart';
import 'package:hearthhome/widgets/alert/confirm_dialog.dart';
import 'package:hearthhome/widgets/delayed_animation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/home.dart';
import 'home.dart';
import '../agora/src/pages/index.dart';

class HomeDetailScreen extends StatefulWidget {
  final HomeData data1;
  HomeDetailScreen({this.data1});
  @override
  State<StatefulWidget> createState() {
    return HomeDetailsScreenState(data: data1);
  }
}

class HomeDetailsScreenState extends State<HomeDetailScreen> {
  var _isloaded = false;
  final HomeData data;
  bool isLoadingMap = false;
  bool confirming = false;
  HomeDetailsScreenState({this.data});
  static String routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    var _auth = Provider.of<Auth>(context);
    _openMap() async {
      setState(() {
        isLoadingMap = true;
      });
      String googleUrl =
          'https://www.google.com/maps/search/?api=1&query=${data.latitude},${data.longitude}';
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
        setState(() {
          isLoadingMap = false;
        });
      } else {
        showDialog(
            context: context,
            builder: (ctx) => CustomAlertDialog(
                  title: 'HearthHome Map',
                  message:
                      'Oops...HearthHome failed to open the map!\nPlease try again later...',
                ));
        setState(() {
          isLoadingMap = false;
        });
      }
    }

    _confirmBooking(){
      showDialog(
        context: context,
        builder: (ctx) => CustomConfirmDialog(
              title: 'HearthHome Confirm Booking',
              message: 'Are you sure you want to proceed with the booking?\nNote that your details will be shared with the Host.\nLikewise, if the Host accepts, you will have their details.',
            ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Wrap(
          children: <Widget>[
            Text(
              data.name,
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Standard',
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CarouselSlider(
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              pauseAutoPlayOnTouch: Duration(seconds: 10),
              scrollDirection: Axis.horizontal,
              height: 300.0,
              items: data.images.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image(
                      image: AdvancedNetworkImage(
                        i,
                        useDiskCache: true,
                        cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                      ),
                      fit: BoxFit.cover,
                    );
                  },
                );
              }).toList(),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DelayedAnimation(
                        delay: 300,
                        child: data.available == 'True'
                            ? Icon(MdiIcons.checkCircle,
                                color: Theme.of(context).primaryColor)
                            : Icon(MdiIcons.exclamation,
                                color: Theme.of(context).primaryColor),
                      ),
                      DelayedAnimation(
                        delay: 300,
                        child: Text(
                            data.available == 'True'
                                ? 'Available'
                                : 'Not Available',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Standard',
                              color: Theme.of(context).primaryColor,
                            )),
                      )
                    ],
                  ),
                )),
            DelayedAnimation(
              delay: 300,
              child: Padding(
                child: Text('Address',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Standard',
                      color: Theme.of(context).primaryColor,
                    )),
                padding: EdgeInsets.all(10),
              ),
            ),
            DelayedAnimation(
              delay: 300,
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  data.address,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Standard',
                    color: Theme.of(context).primaryColor,
                  ),
                  softWrap: true,
                ),
              ),
            ),
            DelayedAnimation(
              delay: 300,
              child: Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: MaterialButton(
                  onPressed: isLoadingMap ? null : _openMap,
                  child: isLoadingMap
                      ? CircularProgressIndicator()
                      : Text(
                          'OPEN MAP',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Standard',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  color: Theme.of(context).accentColor,
                  elevation: 0,
                  minWidth: 400,
                  height: 50,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            DelayedAnimation(
              delay: 300,
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  'Household',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Standard',
                    color: Theme.of(context).primaryColor,
                  ),
                  softWrap: true,
                ),
              ),
            ),
            DelayedAnimation(
              delay: 300,
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  data.adultMale + ' Male Adults',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Standard',
                    color: Theme.of(context).primaryColor,
                  ),
                  softWrap: true,
                ),
              ),
            ),
            DelayedAnimation(
              delay: 300,
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  data.adultFemale + ' Female Adults',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Standard',
                    color: Theme.of(context).primaryColor,
                  ),
                  softWrap: true,
                ),
              ),
            ),
            DelayedAnimation(
              delay: 300,
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  data.childrenMale + ' Male Children',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Standard',
                    color: Theme.of(context).primaryColor,
                  ),
                  softWrap: true,
                ),
              ),
            ),
            DelayedAnimation(
              delay: 300,
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  data.childrenFemale + ' Female Children',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Standard',
                    color: Theme.of(context).primaryColor,
                  ),
                  softWrap: true,
                ),
              ),
            ),
            DelayedAnimation(
              delay: 300,
              child: Padding(
                padding: EdgeInsets.only(top: 20, left: 15, right: 15),
                child: MaterialButton(
                  onPressed: () {},
                  child: SingleChildScrollView(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        Icon(MdiIcons.phone, color: Color(0xfff3f5ff)),
                        Text(
                          'VOICE CALL',
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
            ),
            DelayedAnimation(
              delay: 300,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 20, left: 15, right: 15),
                child: _isloaded
                    ? CircularProgressIndicator()
                    : MaterialButton(
                        onPressed: () async {
                          setState(() {
                            _isloaded = true;
                          });
                          FirebaseDatabase db = FirebaseDatabase.instance;
                          String _hostName = '';
                          String _touristname = '';
                          await db
                              .reference()
                              .child('Users')
                              .child('Host')
                              .child(data.key)
                              .child('Name')
                              .once()
                              .then((name) {
                            _hostName = name.value;
                          });
                          await db
                              .reference()
                              .child('Users')
                              .child('Tourist')
                              .child(_auth.userId)
                              .child('Name')
                              .once()
                              .then((name) {
                            _touristname = name.value;
                          });
                          DatabaseReference dbRef = db
                              .reference()
                              .child('Notifications')
                              .child(data.key)
                              .child(_auth.userId);

                          dbRef.set({
                            'ChannelID': (_auth.userId + data.key).toString(),
                            'Status': 1,
                            'Timestamp': ServerValue.timestamp,
                            'HostName': _hostName,
                            'TouristName': _touristname,
                          }).whenComplete(() async {
                            print('send notif');
                            await PermissionHandler().requestPermissions(
                              [
                                PermissionGroup.camera,
                                PermissionGroup.microphone
                              ],
                            );
                            // push video page with given channel name
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CallPage(
                                  channelName:
                                      (_auth.userId + data.key).toString(),
                                ),
                              ),
                            );
                            dbRef.set({
                              'ChannelID': (_auth.userId + data.key).toString(),
                              'Status': 0,
                              'Timestamp': ServerValue.timestamp,
                              'HostName': _hostName,
                              'TouristName': _touristname,
                            }).then((onValue) {
                              print('call end');
                              setState(() {
                                _isloaded = false;
                              });
                            });
                          }).catchError((onError) {
                            print(onError);
                          });
                        },
                        child: SingleChildScrollView(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                              Icon(MdiIcons.video, color: Color(0xfff3f5ff)),
                              Text(
                                'VIDEO CALL',
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
            ),
              DelayedAnimation(
              delay: 300,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 20, bottom: 10, left: 15, right: 15),
                child: confirming
                    ? CircularProgressIndicator()
                    : MaterialButton(
                        onPressed:confirming?null:_confirmBooking,                         
                         
                        child: SingleChildScrollView(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                              Icon(MdiIcons.check, color: Color(0xfff3f5ff)),
                              Text(
                                'CONFIRM BOOKING',
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
            ),
          ],
        ),
      ),
    );
  }
}
