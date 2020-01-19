import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:hearthhome/models/enum.dart';
import 'package:hearthhome/models/keys.dart';
import 'package:hearthhome/provider/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hearthhome/screens/notification.dart';
import 'package:hearthhome/services/name_validator.dart';
import 'package:hearthhome/widgets/alert/alert_dialog.dart';
import 'package:hearthhome/widgets/circular_image_view.dart';
import 'package:hearthhome/widgets/delayed_animation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:provider/provider.dart';

class ProviderInfo extends StatefulWidget {
  static const routeName = 'providerInfo';
  @override
  State<StatefulWidget> createState() {
    return ProviderInfoState();
  }
}

class ProviderInfoState extends State<ProviderInfo> {
  @override
  void dispose() {
    super.dispose();
  }

  bool submitting = false;

  LocationResult result;
  double latitude, longitude;
  Country _country = Country.IN;
  List<File> houseImageFile = new List<File>();
  List<String> houseImage = new List<String>();
  String name,
      address,
      countryName,
      phone,
      pincode,
      govID,
      govIDURL = 'NA',
      adultMale,
      adultFemale,
      childrenMale,
      childrenFemale;
  File govIDFile;
  final _govCode = TextEditingController();
  final _addressController = TextEditingController();
  final _nameController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _adultMaleController = TextEditingController();
  final _adultFemaleController = TextEditingController();
  final _childrenMaleController = TextEditingController();
  final _childrenFemaleController = TextEditingController();
  FirebaseDatabase db = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    Auth _auth = Provider.of<Auth>(context);
    DatabaseReference dbRef =
        db.reference().child('Users').child('Host').child(_auth.userId);

    _pickLocation() async {
      LocationResult result = await showLocationPicker(context, apiKey);
      latitude = result.latLng.latitude;
      longitude = result.latLng.longitude;
      print(latitude);
      print(longitude);
    }

    _pickImage() async {
      await ImagePicker.pickImage(source: ImageSource.gallery).then((val) {
        setState(() {
          govIDURL = val.path;
          govIDFile = val;
        });
      });
    }

    _pickHouseImage() async {
      await ImagePicker.pickImage(source: ImageSource.gallery).then((val) {
        setState(() {
          houseImage.add(val.path);
          houseImageFile.add(val);
        });
      });
    }

    _submitDetails() async {
      name = _nameController.text;
      address = _addressController.text;
      countryName = _country.name;
      phone = _country.dialingCode + _phoneController.text;
      pincode = _pinCodeController.text;
      govID = _govCode.text;
      adultMale = _adultMaleController.text;
      adultFemale = _adultFemaleController.text;
      childrenMale = _childrenMaleController.text;
      childrenFemale = _childrenFemaleController.text;
      if (NameValidator.validate(name) &&
          phone.length == 12 &&
          address.isNotEmpty &&
          govID.isNotEmpty &&
          govIDFile != null &&
          houseImageFile.length != 0 &&
          pincode.length == 6 &&
         // latitude != null &&
          //longitude != null &&
          adultFemale != null &&
          adultMale != null &&
          childrenMale != null &&
          childrenFemale != null) {
        if (int.parse(adultMale) <= 5 &&
            int.parse(adultFemale) <= 5 &&
            int.parse(childrenMale) <= 5 &&
            int.parse(childrenFemale) <= 5) {
          setState(() {
            submitting = true;
          });

          StorageReference govIDRef = FirebaseStorage.instance
              .ref()
              .child('Host')
              .child(_auth.userId)
              .child('GovID');
          StorageUploadTask uploadTask = govIDRef.putFile(govIDFile);
          StorageTaskSnapshot snapshot = await uploadTask.onComplete;
          govIDURL = await snapshot.ref.getDownloadURL();

          List<String> houseImageURL = List<String>();
          var i = 0;
          houseImageFile.forEach((f) async {
            print('Before:-' + i.toString());
            StorageReference ref = FirebaseStorage.instance
                .ref()
                .child('Host')
                .child(_auth.userId)
                .child('HouseImages')
                .child(i.toString());
            i++;
            StorageUploadTask uploadTask = ref.putFile(f);
            StorageTaskSnapshot snapshot = await uploadTask.onComplete;
            houseImageURL.add(await snapshot.ref.getDownloadURL());
            print('After:-' + i.toString());
            if (i == houseImageFile.length) {
              print('done');
              dbRef.set({
                'Name': name,
                'HouseImages': houseImageURL.join(','),
                'Address': {
                  'Value': address,
                  'Latitude': latitude.toString(),
                  'Longitude': longitude.toString(),
                  'Pincode': pincode
                },
                'Phone': phone,
                'Available': 'True',
                'Household': {
                  'AdultMale': adultMale,
                  'AdultFemale': adultFemale,
                  'ChildrenMale': childrenMale,
                  'ChildrenFemale': childrenFemale
                },
                'GovID': govID,
                'GovIDURL': govIDURL
              }).then((onValue) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => NotificationScreen()));
                setState(() {
                  submitting = false;
                });
              }).catchError((onError) {
                showDialog(
                    context: context,
                    builder: (ctx) => CustomAlertDialog(
                          title: 'HearthHome Details',
                          message:
                              'Oops...HearthHome failed to save your details!\nPlease try again later...',
                        ));
              });
            }
          });
        } else {
          showDialog(
              context: context,
              builder: (ctx) => CustomAlertDialog(
                    title: 'HearthHome Details',
                    message: 'Please enter valid Household details!',
                  ));
        }
      } else {
        showDialog(
            context: context,
            builder: (ctx) => CustomAlertDialog(
                  title: 'HearthHome Details',
                  message: 'Please enter valid details!',
                ));
      }
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xff2893ff)),
          backgroundColor: Color(0xfff3f5ff),
          elevation: 1.0,
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircularImageView(
                w: 50,
                h: 50,
                imageLink: 'assets/icon/icon_round.png',
                imgSrc: ImageSourceENUM.Asset,
              ),
              Wrap(children: <Widget>[
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
                ),
              ])
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: SingleChildScrollView(
              child: DelayedAnimation(
            delay: 200,
            child: Column(
              children: <Widget>[
                Wrap(children: <Widget>[
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
                Padding(
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
                Wrap(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Standard',
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
                Padding(
                  padding: EdgeInsets.only(top: 30, left: 5, right: 5),
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        new Flexible(
                          child: TextFormField(
                            maxLines: 3,
                            controller: _addressController,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontFamily: 'Standard'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Address',
                                prefixIcon: Icon(
                                  MdiIcons.map,
                                  color: Theme.of(context).primaryColor,
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Standard',
                                  color: Theme.of(context).primaryColor,
                                )),
                          ),
                        ),
                        FlatButton(
                            onPressed: _pickLocation,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).accentColor,
                              ),
                              child: Icon(MdiIcons.mapMarker,
                                  color: Color(0xfff3f5ff), size: 34),
                            ))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _pinCodeController,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Standard'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Pincode',
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
                Wrap(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Phone',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Standard',
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
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
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Standard'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Phone',
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
                Wrap(children: <Widget>[
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
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: TextFormField(
                    controller: _govCode,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Standard'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Government Issued Identification Number',
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
                              image: DecorationImage(
                                  image: FileImage(govIDFile)))),
                ),
                Padding(
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
                Wrap(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Household',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Standard',
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: TextFormField(
                    controller: _adultMaleController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Standard'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adult Males',
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
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: TextFormField(
                    controller: _adultFemaleController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Standard'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adult Females',
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
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: TextFormField(
                    controller: _childrenMaleController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Standard'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Children Males',
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
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: TextFormField(
                    controller: _childrenFemaleController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Standard'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Children Females',
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
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 50, right: 50),
                    child: houseImageFile.length == 0
                        ? Text(
                            'Upload some images of your house.',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Standard',
                              color: Theme.of(context).primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : SizedBox(
                            height: 500,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: houseImageFile.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                            height: 300,
                                            width: 300,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: FileImage(
                                                        houseImageFile[
                                                            index])))),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 2, left: 5, right: 5),
                                          child: FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  houseImage.removeAt(index);
                                                  houseImageFile
                                                      .removeAt(index);
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(2),
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                                child: Icon(MdiIcons.cancel,
                                                    color: Color(0xfff3f5ff),
                                                    size: 34),
                                              )),
                                        )
                                      ],
                                    ));
                              },
                            ))),
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                    child: FlatButton(
                        onPressed: _pickHouseImage,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).accentColor,
                          ),
                          child: Icon(MdiIcons.camera,
                              color: Color(0xfff3f5ff), size: 34),
                        ))),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: MaterialButton(
                    onPressed: submitting ? null : _submitDetails,
                    child: submitting
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
              ],
            ),
          )),
        ));
  }
}
