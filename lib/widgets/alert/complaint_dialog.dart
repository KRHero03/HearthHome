import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:true_time/true_time.dart';

import 'alert_dialog.dart';

class ComplaintDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ComplaintDialogState();
  }
}

class ComplaintDialogState extends State<ComplaintDialog> {
  TextEditingController desC = TextEditingController();
  String complaintDescription = '', complaintType = 'Other';
  String complaintID = '';
  String curDate = DateTime.now().millisecondsSinceEpoch.toString();
  bool isRegistering = false;
  FirebaseUser user;
  @override
  initState() {
    super.initState();
    _initPlatformState();
  }

  _initPlatformState() async {
      TrueTime.init(ntpServer: 'pool.ntp.org').whenComplete(() {
        TrueTime.now().then((val) {
          setState(() {
            curDate = val.millisecondsSinceEpoch.toString();
          });
        });
      }).catchError((onError) {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new Scaffold(
                    backgroundColor: Color(0x30000000),
                    body: CustomAlertDialog(
                      title: 'HearthHome - Complaint',
                      message:
                          'Oops..HearthHome failed to load Complaint Registration!\nPlease make sure you are connected to internet!',
                    ))));
      });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    
    _sendComplaint() async {
      isRegistering = true;
      if (desC.text == null || desC.text == '') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new Scaffold(
                    backgroundColor: Color(0x30000000),
                    body: CustomAlertDialog(
                      title: 'HearthHome - Customer Support',
                      message: 'Please enter all the information correctly.',
                    ))));
        isRegistering = false;
      } else {
        complaintDescription = desC.text;
        FirebaseDatabase instance = FirebaseDatabase.instance;
        DatabaseReference dbRef =
            instance.reference().child('Complaints').child(user.uid).push();
        complaintID = dbRef.key;
        dbRef.set({
          'ComplaintDescription': complaintDescription,
          'ComplaintType': complaintType,
          'ComplaintStatus': 'Awaiting Response',
          'ComplaintTimeStamp': curDate,
        }).whenComplete(() {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new Scaffold(
                      backgroundColor: Color(0x30000000),
                      body: CustomAlertDialog(
                        title: 'HearthHome - Complaint',
                        message:
                            'HearthHome registered your Complaint!\nYour Complaint ID:- ' +
                                complaintID +
                                '\nCheck your Complaint Status in Customer Support.\nYou will be contacted via registered Email shortly.',
                      ))));
        }).catchError((onError) {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new Scaffold(
                      backgroundColor: Color(0x30000000),
                      body: CustomAlertDialog(
                        title: 'HearthHome - Complaint',
                        message:
                            'Oops. HearthHome encountered a problem!\nTry again after some time.',
                      ))));
        });
      }
    }

    return AlertDialog(
        backgroundColor: Color(0xfff3f5ff),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/images/logo/round.png',
              width: 50,
              height: 50,
            ),
            Flexible(
              child: Text(
                'HearthHome - Complaint',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Standard',
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.left,
              ),
            )
          ],
        ),
        content: Wrap(children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Complaint Type',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Standard',
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.start,
                  )),
              Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                  child: new DropdownButton<String>(
                    icon: Icon(MdiIcons.chevronDown,
                        color: Theme.of(context).primaryColor, size: 34),
                    isExpanded: true,
                    value: complaintType.toString(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'Standard',
                      fontSize: 20,
                    ),
                    items: <String>[
                      'Other',
                      'Order Delivery Issues',
                      'Payment Issues',
                      'Subscription Issues',
                      'HearthHome Crashes'
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value.toString(),
                        child: new Text(
                          value,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'Standard',
                            fontSize: 20,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        complaintType = val;
                      });
                    },
                  )),
              Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                  child: TextFormField(
                    maxLines: 7,
                    controller: desC,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontFamily: 'Standard'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                        labelStyle: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Standard',
                          color: Theme.of(context).primaryColor,
                        )),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    onPressed: isRegistering ? null : _sendComplaint,
                    child: isRegistering
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  'REGISTERING COMPLAINT... ',
                                  style: isRegistering?TextStyle(
                                    fontSize: 15,
                                    color:Theme.of(context).primaryColor,
                                    fontFamily: 'Standard',
                                    fontWeight: FontWeight.bold,
                                  ):TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Standard',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              CircularProgressIndicator()
                            ],
                          )
                        : Text(
                            'REGISTER COMPLAINT',
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
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'CANCEL',
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
                  )),
            ],
          )
        ]));
  }
}
