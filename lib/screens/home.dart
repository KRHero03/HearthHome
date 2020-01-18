import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:hearthhome/screens/detail_home.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';

import '../models/enum.dart';
import '../widgets/circular_image_view.dart';

class HomeData {
  bool submitting = false;

  double latitude, longitude;
  String name,
      address,
      countryName,
      phone,
      pincode,
      govID,
      govIDURL,
      adultMale,
      adultFemale,
      childrenMale,
      childrenFemale,
      available,
      key;
  List<String> images = new List<String>();

  HomeData(
      {this.name,
      this.address,
      this.phone,
      this.pincode,
      this.govIDURL,
      this.adultMale,
      this.adultFemale,
      this.childrenMale,
      this.images,
      this.childrenFemale,
      this.key,
      this.available});
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<HomeData> data = [];
  var _isloading = true;

  FirebaseDatabase db = FirebaseDatabase.instance;

  @override
  void initState() {
    db.setPersistenceEnabled(true);
    db.setPersistenceCacheSizeBytes(1000000);
    DatabaseReference dbRef = db.reference().child('Users').child('Host');
    dbRef.once().then((snap) {
      Map<dynamic, dynamic> values = snap.value;
      values.forEach((key, values) {
        print(values['Address']['Value']);
        print(values['Household']['ChildrenMale'].toString());
        data.add(HomeData(
          key: key,
          name: values['Name'],
          address: values['Address']['Value'],
          phone: values['Phone'],
          adultMale: values['Household']['AdultMale'],
          adultFemale: values['Household']['AdultFemale'],
          childrenFemale: values['Household']['ChildrenFemale'],
          childrenMale: values['Household']['ChildrenMale'],
          pincode: values['Address']['Pincode'],
          images: values['HouseImages'].toString().split(','),
          available: values['Available'],
        ));
      });
      print(data);
      setState(() {
        _isloading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                  'HearthHome',
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
      body: WillPopScope(
        child: _isloading
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: data.length,
                itemBuilder: (ctx, i) => HomeWidget(
                  data[i],
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
              ),
        onWillPop: () async => false,
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  final HomeData data;

  HomeWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: CarouselSlider(
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            pauseAutoPlayOnTouch: Duration(seconds: 10),
            scrollDirection: Axis.horizontal,
            height: 400.0,
            items: data.images.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Image(
                    image: AdvancedNetworkImage(
                      i,
                      useDiskCache: true,
                      cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                    ),
                    fit: BoxFit.cover,
                  );
                },
              );
            }).toList(),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeDetailScreen(data1: data)));
          },
        ),
        footer: GridTileBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(data.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Standard',
                    )),
                SizedBox(
                  width: 10,
                ),
                data.available == 'True'
                    ? Icon(MdiIcons.checkCircle, color: Color(0xfff3f5ff))
                    : Icon(MdiIcons.exclamation, color: Color(0xfff3f5ff)),
                data.available == 'True'
                    ? Text('Available',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Standard',
                        ))
                    : Text('Not Available',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Standard',
                        )),
              ],
            ),
          ),
          //
        ),
      ),
    );
  }
}
