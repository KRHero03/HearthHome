import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hearthhome/models/enum.dart';
import 'package:hearthhome/widgets/circular_image_view.dart';
import 'package:hearthhome/widgets/delayed_animation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
//import 'package:image_picker_modern/image_picker_modern.dart';
import '../models/tourist_save_data.dart';
import 'dart:async';
import 'dart:io';

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
  var _country;

  void dispose() {
    //9967638666
    _nameController.dispose();
    _numberController.dispose();
    _govCode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LocationResult result;
    String address;
    _pickImage() async {
      await ImagePicker.pickImage(source: ImageSource.gallery).then((val) {
        setState(() {
          govIDURL = val.path;
          govIDFile = val;
        });
      });
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
              delay: 200,
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
            CountryPicker(
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
            SizedBox(
              height: 10,
            ),
            DelayedAnimation(
              delay: 200,
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
              delay: 200,
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
            ),
            DelayedAnimation(
              delay: 200,
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
            DelayedAnimation(
              child: Padding(
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
                            image:
                                DecorationImage(image: FileImage(govIDFile)))),
              ),
              delay: 200,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 5, right: 5),
              child: FloatingActionButton(
                onPressed: _pickImage,
                tooltip: 'Pick Image',
                child: Icon(Icons.add_a_photo),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: ButtonTheme(
        height: 40,
        minWidth: double.infinity,
        child: FlatButton(
          color: Theme.of(context).primaryColor,
          child: Text('Next'),
          onPressed: () async {
            await TouristSaveData().saveData(
              name: _nameController.text,
              govId: _govCode.text,
              phone: _numberController.text,
              gender: 'M',
              profilePicUrl: null,
              govIdUrl: null,
              country: _country.name,
            );
          },
        ),
      ),
    );
  }
}
