import 'package:flutter/material.dart';

class backgroundImg extends StatelessWidget {
  backgroundImg({Key? key, required this.h}) : super(key: key);

  var h;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Image.asset(
        "assets/Icons/BG.png",
        fit: BoxFit.fill,
        height: h,
      ),
    );
  }
}
