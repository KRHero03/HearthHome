import 'package:flutter/material.dart';
import 'package:hearthhome/screens/provider_info.dart';
import 'package:hearthhome/screens/split_screen.dart';
import 'screens/auth-screen.dart';
import 'package:provider/provider.dart';
import './provider/auth.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        )
      ],
      child: MaterialApp(
          title: 'HearthHome',
          theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primaryColor: Color(0xff2893ff),
              accentColor: Color(0xff29ffd6)),
          home: Consumer<Auth>(
              builder: (ctx, auth, _) => MaterialApp(
                    title: 'Hello',
                    home: auth.isAuth
                        ? SplitScreen()
                        : FutureBuilder(
                            future: auth.tryAutoLogin(),
                            builder: (ctx, authResult) =>
                                authResult.connectionState ==
                                        ConnectionState.waiting
                                    ? SplashScreen()
                                    : AuthScreen(),
                          ),
                    routes: {
                      SplitScreen.routeName: (ctx) => SplashScreen(),
                      ProviderInfo.routeName: (ctx) => ProviderInfo()
                    },
                  ))),
    );
  }
}
