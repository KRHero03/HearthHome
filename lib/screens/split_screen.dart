import 'package:flutter/material.dart';
import 'package:hearthhome/screens/provider_info.dart';
import 'package:hearthhome/screens/tourist_screen.dart';

class SplitScreen extends StatelessWidget {
  static const routeName = 'split';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).primaryColor,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Which one are you?',
                      style: TextStyle(
                        fontSize: 35,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProviderInfo()));
                    },
                    child: Text(
                      'I AM A HOST',
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
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TouristInput()));
                    },
                    child: Text(
                      'I AM A TOURIST',
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
              ],
            ),
          ))
    ]));
    /* Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(10),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text('Which one are you?',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Standard',
                      color: Color(0xfff3f5ff),
                    ),
                    textAlign: TextAlign.center,)),),
              Container(
                padding: EdgeInsets.all(10),
                child: ButtonTheme(
                  minWidth: 120.0,
                  height: 70.0,
                  buttonColor: Theme.of(context).accentColor,
                  padding: EdgeInsets.all(10),
                  child: DelayedAnimation(
                    child: FlatButton(
                      color: Theme.of(context).primaryColor,
                      child: Text('Host'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProviderInfo()));
                      },
                    ),
                    delay: 300,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: ButtonTheme(
                  minWidth: 120.0,
                  height: 70.0,
                  buttonColor: Theme.of(context).accentColor,
                  padding: EdgeInsets.all(10),
                  child: DelayedAnimation(
                    child: FlatButton(
                      color: Theme.of(context).primaryColor,
                      child: Text('Tourist'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TouristInput()));
                      },
                    ),
                    delay: 300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );*/
  }
}
