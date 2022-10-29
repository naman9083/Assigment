import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task25/components/backgroundCompoenent.dart';

import '../../Helpers/validation_mixin.dart';
import 'join.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _formPhoneKey = GlobalKey<FormState>();
  TextEditingController phone = TextEditingController();
  String verificationID = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    Color givenBlue = const Color(0xFF314b5c);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            backgroundImg(h: h),
            Positioned(
                left: 20,
                right: 20,
                top: 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Icons/icon1.png',
                      height: 150,
                      width: 150,
                    ),
                    SizedBox(
                      height: .0075 * h,
                    ),
                    Container(
                      height: .75 * h,
                      width: w,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Form(
                        key: _formPhoneKey,
                        child: Column(
                          children: [
                            Container(
                              width: w,
                              height: .15 * h,
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: .02 * h, bottom: .02 * h),
                                    width: .85 * w,
                                    height: .08 * h,
                                    padding: const EdgeInsets.only(
                                        left: 12.0, top: 12.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 10.0,
                                            spreadRadius: 1.0,
                                            offset: Offset(.4, .4),
                                          )
                                        ]),
                                    child: TextFormField(
                                      controller: phone,
                                      style:
                                          const TextStyle(fontFamily: 'Luxia'),
                                      keyboardType: TextInputType.phone,
                                      decoration: const InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 1,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 1,
                                            ),
                                          ),
                                          icon: Icon(
                                            Icons.phone_android_outlined,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                          hintText: 'Enter Phone Number',
                                          hintStyle: TextStyle(
                                              fontFamily: 'Luxia Regular',
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black)),
                                      validator: (phoneNo) {
                                        if (InputValidationMixin.isPhoneValid(
                                            phoneNo: phoneNo)) {
                                          return null;
                                        } else {
                                          return 'Enter a valid Phone No';
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Join(
                                        phNumber: phone.text,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: .39 * w,
                                  height: h * .06,
                                  padding: const EdgeInsets.all(5.0),
                                  child: const Center(
                                    child: Text("SENT OTP",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: "OPTICopperplate")),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
