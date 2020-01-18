import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hearthhome/models/enum.dart';
import 'package:hearthhome/models/keys.dart';
import 'package:hearthhome/widgets/circular_image_view.dart';
import 'package:hearthhome/widgets/delayed_animation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProviderInfo extends StatefulWidget {
  static const routeName = 'providerInfo';
  @override
  State<StatefulWidget> createState() {
    return ProviderInfoState();
  }
}



class ProviderInfoState extends State<ProviderInfo> {

  @override
  void dispose(){
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LocationResult result;
    double latitude, longitude;
    String address;
    _pickLocation() async {
      LocationResult result = await showLocationPicker(context, apiKey);
      latitude = result.latLng.latitude;
      longitude = result.latLng.longitude;
      print(latitude);
      print(longitude);
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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DelayedAnimation(
                delay: 200,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: TextFormField(
                    controller: null,
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
              DelayedAnimation(
                delay: 200,
                child: Padding(
                  padding: EdgeInsets.only(top: 30, left: 5, right: 5),
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        new Flexible(
                          child: TextFormField(
                            maxLines: 3,
                            controller: null,
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
              ),
            ],
          ),
        ));
  }
}
