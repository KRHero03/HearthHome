import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hearthhome/screens/split_screen.dart';
import 'package:hearthhome/services/auth.dart';
import 'package:hearthhome/services/email_validator.dart';
import 'package:hearthhome/widgets/alert/alert_dialog.dart';
import 'package:hearthhome/widgets/delayed_animation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AuthScreen extends StatefulWidget {
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool loading = false;
  bool error;
  String errorMessage;
  String email = '';
  String password = '';
  final AuthService _auth = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
/*
  void _onSwitchSignInMode() {
    setState(() {
      _isPhoneSignIn = !_isPhoneSignIn;
    });
  }*/

  _signInWithEmailandPassword() async {
    setState(() {
      loading = true;
    });
    email = _emailController.text;
    password = _passwordController.text;
    print(password);
    if (EmailValidator.validate(email)) {
      if (password.length > 6 && password.length < 20) {
        FirebaseUser result =
            await _auth.signInWithEmailAndPassword(email, password);
        if (result == null) {
          return showDialog(
              context: context,
              builder: (context) {
                return CustomAlertDialog(
                    title: 'HearthHome - Sign In',
                    message:
                        'You have entered incorrect Email or Password! Try again.');
              });
          setState(() {
            loading = false;
          });
        } else {
          if (result.isEmailVerified) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SplitScreen()));
          } else {
            result.sendEmailVerification().then((val) {
              Fluttertoast.showToast(
                  msg: "Please verify your Email Address!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 2,
                  backgroundColor: Color(0xfff3f5ff),
                  textColor: Theme.of(context).primaryColor,
                  fontSize: 16.0);
            });
            setState(() {
              loading = false;
            });
          }
        }
      } else {
        return showDialog(
            context: context,
            builder: (context) {
              return CustomAlertDialog(
                  title: 'HearthHome - Sign In',
                  message: 'Please enter valid Password! Try again.');
            });
        setState(() {
          loading = false;
        });
      }
    } else {
      return showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
                title: 'HearthHome - Sign In',
                message: 'Please enter valid Email and Password! Try again.');
          });
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            color: Theme.of(context).primaryColor,
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/icon/icon_round.png',
                  width: 100,
                  height: 100,
                ),
                Text('HearthHome',
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: 'Standard',
                      color: Color(0xfff3f5ff),
                    )),
                Text('Experience your home abroad...',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Standard',
                      color: Color(0xfff3f5ff),
                    )),
              ],
            )),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 270),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: DelayedAnimation(
              delay: 200,
              child: ListView(
                children: <Widget>[
                  Text('Sign In to your HearthHome Account',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Standard',
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Container(
                      color: Color(0xfff5f5f5),
                      child: TextFormField(
                        controller: _emailController,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'Standard'),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            prefixIcon: Icon(
                              MdiIcons.email,
                              color: Theme.of(context).primaryColor,
                            ),
                            labelStyle: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Standard',
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                    ),
                  ),
                  Container(
                    color: Color(0xfff3f5ff),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Standard'),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          prefixIcon: Icon(
                            MdiIcons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                          labelStyle: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Standard',
                            color: Theme.of(context).primaryColor,
                          )),
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: MaterialButton(
                      onPressed: loading ? null : _signInWithEmailandPassword,
                      child: loading
                          ? CircularProgressIndicator()
                          : Text(
                              'SIGN IN',
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
                    child: Text(
                      'Forgot Your Password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Standard',
                          color: Theme.of(context).accentColor,
                          fontSize: 15,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
