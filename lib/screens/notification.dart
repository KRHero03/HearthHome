import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hearthhome/agora/src/pages/call.dart';
import 'package:hearthhome/models/enum.dart';
import 'package:hearthhome/provider/auth.dart';
import 'package:hearthhome/screens/edit_profile.dart';
import 'package:hearthhome/screens/guest_screen.dart';
import 'package:hearthhome/screens/home.dart';
import 'package:hearthhome/widgets/circular_image_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotificationScreenState();
  }
}

class NotificationData {
  final String uid, channelID, timeStamp, status, name;
  NotificationData(
      {this.uid, this.channelID, this.timeStamp, this.status, this.name});
}

class NotificationScreenState extends State<NotificationScreen> {
  List<NotificationData> items = [];
  StreamSubscription<Event> _onItemAddedSub,
      _onItemChangedSub,
      _onItemRemovedSub;
  bool submitting = false;
  FirebaseDatabase db = FirebaseDatabase.instance;
  bool isLoading = false;
  void _onItemAdded(Event event) {
    setState(() {
      items = [];
      items.add(new NotificationData(
          name: event.snapshot.value['TouristName'].toString(),
          uid: event.snapshot.key,
          channelID: event.snapshot.value['ChannelID'].toString(),
          timeStamp: event.snapshot.value['Timestamp'].toString(),
          status: event.snapshot.value['Status'].toString()));
    });
  }

  void _onItemChanged(Event event) {
    var oldItemVal =
        items.singleWhere((item) => item.uid == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldItemVal)] = new NotificationData(
          name: event.snapshot.value['TouristName'].toString(),
          uid: event.snapshot.key,
          channelID: event.snapshot.value['ChannelID'].toString(),
          timeStamp: event.snapshot.value['Timestamp'].toString(),
          status: event.snapshot.value['Status'].toString());
    });
  }


  void initState() {
    db.setPersistenceEnabled(true);
    db.setPersistenceCacheSizeBytes(1000000);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Auth _auth = Provider.of<Auth>(context);
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('Notifications')
        .child(_auth.userId);

    _onItemAddedSub = ref.onChildAdded.listen(_onItemAdded);
    _onItemChangedSub = ref.onChildChanged.listen(_onItemChanged);
    ref.keepSynced(true);
    return Scaffold(
        drawer: Drawer(
            child: Column(
          children: <Widget>[
            AppBar(
              title: Text('Hello '),
              automaticallyImplyLeading: false,
            ),
            Divider(),
            ListTile(
              leading:
                  Icon(MdiIcons.account, color: Theme.of(context).primaryColor),
              title: Text('Edit Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Standard',
                    color: Theme.of(context).primaryColor,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfileHostScreen()));
              },
            ),
             ListTile(
              leading: Icon(MdiIcons.accountGroup,
                  color: Theme.of(context).primaryColor),
              title: Text('Guest',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Standard',
                    color: Theme.of(context).primaryColor,
                  )),
              onTap: () {Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GuestScreen()));},
            ),
            ListTile(
              leading: Icon(MdiIcons.information,
                  color: Theme.of(context).primaryColor),
              title: Text('About',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Standard',
                    color: Theme.of(context).primaryColor,
                  )),
              onTap: () {},
            ),
          ],
        )),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: Color(0xff2893ff)),
          backgroundColor: Color(0xfff3f5ff),
          elevation: 1.0,
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                 
                },
                child: CircularImageView(
                  w: 50,
                  h: 50,
                  imageLink: 'assets/icon/icon_round.png',
                  imgSrc: ImageSourceENUM.Asset,
                ),
              ),
              Wrap(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    'HearthHome - Set Up',
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
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      background: Container(color: Colors.red),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        items.removeAt(index);
                        db
                            .reference()
                            .child('Notifications')
                            .child(_auth.userId)
                            .child(items[index].uid)
                            .remove();
                        Fluttertoast.showToast(
                            msg: "Deleted Call Notification!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 2,
                            backgroundColor: Theme.of(context).primaryColor,
                            textColor: Color(0xfff3f5ff),
                            fontSize: 16.0);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        elevation: 3.0,
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xfff3f5ff),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(items[index].name),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: MaterialButton(
                                      onPressed: submitting
                                          ? null
                                          : () async {
                                              String _hostName = '';
                                              String _touristname = '';
                                              FirebaseDatabase db =
                                                  FirebaseDatabase.instance;
                                              await db
                                                  .reference()
                                                  .child('Users')
                                                  .child('Host')
                                                  .child(_auth.userId)
                                                  .child('Name')
                                                  .once()
                                                  .then((name) {
                                                _hostName = name.value;
                                              });
                                              await db
                                                  .reference()
                                                  .child('Users')
                                                  .child('Tourist')
                                                  .child(items[index].uid)
                                                  .child('Name')
                                                  .once()
                                                  .then((name) {
                                                _touristname = name.value;
                                              });
                                              if (items[index].status == '1') {
                                                await PermissionHandler()
                                                    .requestPermissions(
                                                  [
                                                    PermissionGroup.camera,
                                                    PermissionGroup.microphone
                                                  ],
                                                );
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CallPage(
                                                      channelName: items[index]
                                                          .channelID,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                DatabaseReference dbRef = db
                                                    .reference()
                                                    .child('Notifications')
                                                    .child(_auth.userId)
                                                    .child(items[index].uid);
                                                dbRef.set({
                                                  'ChannelID':
                                                      (items[index].uid +
                                                              _auth.userId)
                                                          .toString(),
                                                  'Status': 1,
                                                  'Timestamp':
                                                      ServerValue.timestamp,
                                                  'HostName': _hostName,
                                                  'TouristName': _touristname,
                                                }).whenComplete(() async {
                                                  print('send notif');
                                                  await PermissionHandler()
                                                      .requestPermissions(
                                                    [
                                                      PermissionGroup.camera,
                                                      PermissionGroup.microphone
                                                    ],
                                                  );
                                                  // push video page with given channel name
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CallPage(
                                                        channelName:
                                                            (items[index].uid +
                                                                    _auth
                                                                        .userId)
                                                                .toString(),
                                                      ),
                                                    ),
                                                  );
                                                  dbRef.set({
                                                    'ChannelID':
                                                        (items[index].uid +
                                                                _auth.userId)
                                                            .toString(),
                                                    'Status': 0,
                                                    'Timestamp':
                                                        ServerValue.timestamp,
                                                    'HostName': _hostName,
                                                    'TouristName': _touristname,
                                                  }).then((onValue) {
                                                    print('call end');
                                                  });
                                                }).catchError((onError) {
                                                  print(onError);
                                                });
                                              }
                                            },
                                      child: submitting
                                          ? CircularProgressIndicator()
                                          : SingleChildScrollView(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(MdiIcons.phone),
                                                  Text(
                                                    items[index].status == '0'
                                                        ? 'CALL AGAIN'
                                                        : 'RECIEVE',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'Standard',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      color: Theme.of(context).accentColor,
                                      elevation: 0,
                                      minWidth: 400,
                                      height: 50,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                      key: ValueKey(index),
                    );
                  },
                ),
          onWillPop: () async => false,
        ));
  }
}
