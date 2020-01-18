
import 'package:flutter/material.dart';
import 'package:hearthhome/screens/wrapper.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => new _IntroState();
}

class _IntroState extends State<Intro> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "HearthHome",
        styleTitle: TextStyle(
          fontSize: 50,
          fontFamily: 'Standard',
          color: Color(0xfff3f5ff),
        ),
        styleDescription: TextStyle(
          fontSize: 25,
          fontFamily: 'Standard',
          color: Color(0xfff3f5ff),
        ),
        description: "Your one stop App for pure experiences of your tours throughout",
        pathImage: 'assets/images/Intro/Slide1.png',
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
    slides.add(
      new Slide(
        title: "On your Tips!",
        styleTitle: TextStyle(
          fontSize: 50,
          fontFamily: 'Standard',
          color: Theme.of(context).primaryColor,
        ),
        styleDescription: TextStyle(
          fontSize: 25,
          fontFamily: 'Standard',
          color: Theme.of(context).primaryColor,
        ),
        description:
            "All your bookings on your fingertips. Find a heart-warming home that will match your personality and experience the local life to the fullest!",
        pathImage: "assets/images/Intro/Slide2.png",
        backgroundColor: Color(0xfff3f5ff),
      ),
    );
    slides.add(
      new Slide(
        title: "Customizable Delivery Options",
        maxLineTitle: 2,
        styleTitle: TextStyle(
          fontSize: 50,
          fontFamily: 'Standard',
          color: Color(0xfff3f5ff),
        ),
        styleDescription: TextStyle(
          fontSize: 25,
          fontFamily: 'Standard',
          color: Color(0xfff3f5ff),
        ),
        description:
            "Already got plans? We understand. Cancel your subsciptions anytime, for any day, but, before they are delivered!",
        pathImage: "assets/images/Intro/Slide3.png",
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void onDonePress() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Wrapper()));
  }

  void onSkipPress() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Wrapper()));
  }

  Widget renderNextBtn() {
    return Icon(
      MdiIcons.chevronRight,
      color: Theme.of(context).accentColor,
      size: 40
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      MdiIcons.check,
      color: Theme.of(context).accentColor,
      size: 40
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      MdiIcons.chevronDoubleRight,
      color: Theme.of(context).accentColor,
      size: 40
    );
  }


  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      onSkipPress: this.onSkipPress,
      renderDoneBtn: renderDoneBtn(),
      renderNextBtn: renderNextBtn(),
      renderSkipBtn: renderSkipBtn(),
      colorDot: Color(0xff000000),
      colorActiveDot: Theme.of(context).accentColor,
      sizeDot: 10.0,
    );
  }
}
