import 'package:flutter/material.dart';
import 'package:hearthhome/screens/provider_info.dart';
import 'package:hearthhome/screens/tourist_screen.dart';
import 'package:hearthhome/widgets/delayed_animation.dart';

class SplitScreen extends StatelessWidget {
  static const routeName = 'split';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Who You Are?'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
    );
  }
}
