import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/home.dart';
import 'home.dart';

class HomeDetailScreen extends StatelessWidget {
  final HomeData data;

  HomeDetailScreen(this.data);
  static String routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                data.images,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              data.address,
              textAlign: TextAlign.center,
              softWrap: true,
            )
          ],
        ),
      ),
    );
  }
}
