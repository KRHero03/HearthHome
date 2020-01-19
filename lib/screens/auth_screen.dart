import 'dart:math';
import 'package:hearthhome/models/enum.dart';
import 'package:hearthhome/widgets/alert/alert_dialog.dart';
import 'package:hearthhome/widgets/circular_image_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../provider/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.5),
                  Theme.of(context).primaryColor.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularImageView(
                        h: 150,
                        w: 150,
                        imageLink: 'assets/icon/icon_round.png',
                        imgSrc: ImageSourceENUM.Asset,
                      )),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'HearthHome',
                        style: TextStyle(
                          color: Color(0xfff3f5ff),
                          fontSize: 40,
                          fontFamily: 'Standard',
                        ),
                      )),
                  Padding(padding: EdgeInsets.all(10), child: AuthCard())
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => CustomAlertDialog(
              title: 'HearthHome Sign In',
              message: message == null
                  ? 'Oops...An error occured!\nPlease try again later.'
                  : message,
            ));
  }

  final _passwordController = TextEditingController();

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .logIn(_authData['email'], _authData['password']);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email'], _authData['password']);
      }
    } catch (error) {
      var message = 'Oops...An error occured!\nPlease try again later.';
      if (error.toString().contains('EMAIL_EXISTS')) {
        message = 'This email is already in use!\nPlease check your email!';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        message = 'Please check your email!';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        message = 'Your password is too weak!\nPlease check your password.';
      }
      _showErrorDialog(message);
    } catch (error) {
      var message = 'Oops...An error occured!\nPlease try again later.';
      _showErrorDialog(message);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 340 : 280),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                    },
                    onSaved: (value) {
                      _authData['email'] = value;
                    },
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Standard'),
                    decoration: InputDecoration(
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
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Standard'),
                    decoration: InputDecoration(
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
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: (_authMode == AuthMode.Signup)
                      ? TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'Standard'),
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: Icon(
                              MdiIcons.lock,
                              color: Theme.of(context).primaryColor,
                            ),
                            labelStyle: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Standard',
                          color: Theme.of(context).primaryColor,
                        )
                          ),
                          
                          obscureText: true,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                }
                              : null,
                        )
                      : null,
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
