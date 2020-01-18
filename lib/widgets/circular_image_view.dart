import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:hearthhome/models/enum.dart';

class CircularImageView extends StatelessWidget {
  final double h, w;
  final imageLink;
  final ImageSourceENUM imgSrc;
  CircularImageView({this.h, this.w, this.imageLink, this.imgSrc});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.only(bottom: 20),
      alignment: Alignment.center,
      width: w,
      height: h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imgSrc == ImageSourceENUM.Asset
              ? AssetImage(imageLink.toString())
              : (imgSrc == ImageSourceENUM.Network
                  ? AdvancedNetworkImage(imageLink,
                          useDiskCache: true,
                          cacheRule:
                              CacheRule(maxAge: const Duration(days: 30)))
                      : FileImage(imageLink)),
        ),
        shape: BoxShape.circle,
      ),
      duration: Duration(milliseconds: 500),
    );
  }
}
