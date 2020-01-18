import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hearthhome/models/enum.dart';
import 'package:hearthhome/provider/auth.dart';
import 'package:hearthhome/screens/home.dart';
import 'package:hearthhome/widgets/circular_image_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotificationScreenState();
  }
}

class NotificationData {
  final String uid, channelID, timeStamp, status;
  NotificationData({this.uid, this.channelID, this.timeStamp, this.status});
}

class NotificationScreenState extends State<NotificationScreen> {
  List<NotificationData> items;
  StreamSubscription<Event> _onItemAddedSub,
      _onItemChangedSub,
      _onItemRemovedSub;
  bool submitting = false;
  FirebaseDatabase db = FirebaseDatabase.instance;
  bool isLoading = false;
  void _onItemAdded(Event event) {
    setState(() {
      items.add(new NotificationData(
          uid: event.snapshot.key,
          channelID: event.snapshot.value['ChannelID'],
          timeStamp: event.snapshot.value['Timestamp'],
          status: event.snapshot.value['Status']));
    });
  }

  void _onItemChanged(Event event) {
    var oldItemVal =
        items.singleWhere((item) => item.uid == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldItemVal)] = new NotificationData(
          uid: event.snapshot.key,
          channelID: event.snapshot.value['ChannelID'],
          timeStamp: event.snapshot.value['Timestamp'],
          status: event.snapshot.value['Status']);
    });
  }

  void _onItemRemoved(Event event) {
    var oldItemVal =
        items.singleWhere((item) => item.uid == event.snapshot.key);
    setState(() {
      items.removeAt(items.indexOf(oldItemVal));
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
    _onItemRemovedSub = ref.onChildRemoved.listen(_onItemRemoved);
    ref.keepSynced(true);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      elevation: 3.0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xfff3f5ff),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            height: 200,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(items[index].uid),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: MaterialButton(
                                      onPressed: submitting ? null : () {},
                                      child: submitting
                                          ? CircularProgressIndicator()
                                          : SingleChildScrollView(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(MdiIcons.phone),
                                                  Text(
                                                    items[index].status == '0'
                                                        ? 'CALL AGAIN'
                                                        : 'CALL',
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
                    );
                  },
                ),
          onWillPop: () async => false,
        ));
  }
}
