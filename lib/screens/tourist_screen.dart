import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hearthhome/models/enum.dart';
import 'package:hearthhome/screens/home.dart';
import 'package:hearthhome/services/name_validator.dart';
import 'package:hearthhome/widgets/alert/alert_dialog.dart';
import 'package:hearthhome/widgets/circular_image_view.dart';
import 'package:hearthhome/widgets/delayed_animation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:provider/provider.dart';
//import 'package:image_picker_modern/image_picker_modern.dart';
import '../models/tourist_save_data.dart';
import 'dart:async';
import 'dart:io';
import '../provider/auth.dart';

class TouristInput extends StatefulWidget {
  static const routeName = 'TouristInput';
  @override
  State<StatefulWidget> createState() {
    return TouristInputState();
  }
}

class TouristInputState extends State<TouristInput> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _govCode = TextEditingController();
  File govIDFile;
  String govIDURL = 'NA';
  var _gender = ['Male', 'Female'];
  var _selectedGender = 0;
  var _country;

  var _isloading = false;
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _govCode.dispose();

    super.dispose();
  }

  _pickImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((val) {
      setState(() {
        govIDURL = val.path;
        govIDFile = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _auth = Provider.of<Auth>(context);

    _submitDetails() async {
      if (_nameController.text.isNotEmpty &&
          NameValidator.validate(_nameController.text) &&
          _govCode.text.isNotEmpty &&
          (_country.dialingCode.length + _numberController.text.length) == 12 &&
          govIDURL != null) {
        setState(() {
          _isloading = true;
        });
        StorageReference govIDRef = FirebaseStorage.instance
            .ref()
            .child('Tourist')
            .child(_auth.userId)
            .child('GovID');
        StorageUploadTask uploadTask = govIDRef.putFile(govIDFile);
        StorageTaskSnapshot snapshot = await uploadTask.onComplete;
        govIDURL = await snapshot.ref.getDownloadURL();
        await TouristSaveData().saveData(
          name: _nameController.text,
          govId: _govCode.text,
          phone: '+${_country.dialingCode}${_numberController.text}',
          gender: _gender[_selectedGender],
          profilePicUrl: '',
          govIdUrl: govIDURL,
          userID: _auth.userId,
          country: _country.name,
        );
        setState(() {
          _isloading = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        showDialog(
            context: context,
            builder: (ctx) => CustomAlertDialog(
                  title: 'HearthHome Details',
                  message: 'Please enter valid Household details!',
                ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xff2893ff)),
        backgroundColor: Color(0xfff3f5ff),
        elevation: 1.0,
        title: FittedBox(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircularImageView(
                w: 50,
                h: 50,
                imageLink: 'assets/icon/icon_round.png',
                imgSrc: ImageSourceENUM.Asset,
              ),
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
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DelayedAnimation(
                child: Wrap(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Please enter your details...',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Standard',
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
                delay: 300),
            DelayedAnimation(
              delay: 300,
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                child: TextFormField(
                  controller: _nameController,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'Standard'),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Full Name',
                      prefixIcon: Icon(
                        MdiIcons.accountCircle,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Standard',
                        color: Theme.of(context).primaryColor,
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            DelayedAnimation(
              delay: 300,
              child: Row(
                children: <Widget>[
                  new Radio(
                    value: 0,
                    groupValue: _selectedGender,
                    onChanged: (i) {
                      setState(() {
                        _selectedGender = i;
                      });
                    },
                  ),
                  new Text(
                    'Male',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Standard',
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  new Radio(
                    value: 1,
                    groupValue: _selectedGender,
                    onChanged: (i) {
                      setState(() {
                        _selectedGender = i;
                      });
                    },
                  ),
                  new Text(
                    'Female',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Standard',
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            DelayedAnimation(
                child: Wrap(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Contact',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Standard',
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
                delay: 300),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 5, right: 5),
              child: CountryPicker(
                dense: false,
                showFlag: true,
                showDialingCode: true,
                showName: true,
                showCurrency: false,
                showCurrencyISO: false,
                onChanged: (Country country) {
                  setState(() {
                    _country = country;
                  });
                },
                selectedCountry: _country,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            DelayedAnimation(
              delay: 300,
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                child: TextFormField(
                  controller: _numberController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'Standard'),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone Number',
                      prefixIcon: Icon(
                        MdiIcons.phone,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Standard',
                        color: Theme.of(context).primaryColor,
                      )),
                ),
              ),
            ),
            DelayedAnimation(
                child: Wrap(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Identification',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Standard',
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
                delay: 300),
            DelayedAnimation(
              delay: 300,
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                child: TextFormField(
                  controller: _govCode,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'Standard'),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '',
                      prefixIcon: Icon(
                        MdiIcons.codeBracesBox,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Standard',
                        color: Theme.of(context).primaryColor,
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 5, right: 5),
              child: govIDURL == 'NA'
                  ? Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Upload your Government ID Photo',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Standard',
                          color: Theme.of(context).primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: FileImage(govIDFile)))),
            ),
            DelayedAnimation(
              child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: FlatButton(
                      onPressed: _pickImage,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).accentColor,
                        ),
                        child: Icon(MdiIcons.camera,
                            color: Color(0xfff3f5ff), size: 34),
                      ))),
            ),
            SizedBox(
              height: 10,
            ),
            DelayedAnimation(
              delay: 300,
              child: Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: MaterialButton(
                  onPressed: _isloading ? null : _submitDetails,
                  child: _isloading
                      ? CircularProgressIndicator()
                      : Text(
                          'SUBMIT DETAILS',
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
            )
          ],
        ),
      ),
    );
  }
}
