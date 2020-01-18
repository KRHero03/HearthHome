import 'package:flutter/material.dart';
import 'package:hearthhome/screens/provider_info.dart';
import 'screens/auth-screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HearthHome',
      theme: ThemeData(
        primaryColor: Color(0xff2893ff),
        accentColor: Color(0xff29ffd6),        
      ),
      home: ProviderInfo(),
    );
  }
}
