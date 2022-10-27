import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task25/views/home/home.dart';
import 'package:task25/views/home/userData.dart';
import 'package:task25/views/login/login.dart';

class splash extends StatefulWidget {
  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => auth.currentUser == null
            ? Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const login()))
            : Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const userData())));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Image.asset(
              "assets/Icons/BG.png",
              fit: BoxFit.fitHeight,
            ),
          ),
          Center(
            child: Image.asset(
              'assets/Icons/icon1.png',
              width: 500,
              height: 500,
            ),
          )
        ],
      ),
    );
  }
}
