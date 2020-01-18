import 'package:flutter/material.dart';
import 'package:hearthhome/screens/provider_info.dart';
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
                buttonColor: Colors.blue,
                padding: EdgeInsets.all(10),
                child: DelayedAnimation(
                  child: FlatButton(
                    color: Colors.blue,
                    child: Text('Host'),
                    onPressed: (){Navigator.pushNamed(context, ProviderInfo.routeName);},
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
                buttonColor: Colors.blue,
                padding: EdgeInsets.all(10),
                child: DelayedAnimation(
                  child: FlatButton(
                    color: Colors.blue,
                    child: Text('Tourist'),
                    onPressed: (){},
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
