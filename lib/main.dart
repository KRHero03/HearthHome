import 'package:flutter/material.dart';
import 'package:hearthhome/screens/auth_screen.dart';
import 'package:provider/provider.dart';
import './screens/splash_screen.dart';
import './provider/auth.dart';
import './screens/split_screen.dart';
import 'screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  /*Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
        child: MaterialApp(
            theme: ThemeData(
              primaryColor: Color(0xff4564e5),
              accentColor: Color(0xff4edbf2),
            ),
            home:Splash(),),
            providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
        ],);
  }
}
class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  Future checkFirstSeen() async {
    await SharedPreferences.getInstance().then((prefs) {
     // bool _seen = (prefs.getBool('seen') ?? false);
    //  print(_seen);
     // if (!_seen) {
       
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new Wrapper()));
     } else {
        prefs.setBool('seen', true);
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (context) => new Scaffold(
                  body: Container(child:Text('Text')),
                )));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }*/

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
        ],
        child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
                  title: 'HearthHome',
                  theme: ThemeData(
                    primaryColor: Color(0xff2893ff),
                    accentColor: Color(0xff29ffd6),
                    fontFamily: 'Standard',
                  ),
                  home: auth.isAuth
                      ? Home()
                      : FutureBuilder(
                          future: auth.tryAutoLogin(),
                          builder: (ctx, authResult) =>
                              authResult.connectionState ==
                                      ConnectionState.waiting
                                  ? SplashScreen()
                                  : AuthScreen(),
                        ),
                  routes: {},
                )));
  }
}
