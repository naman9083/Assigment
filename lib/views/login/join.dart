import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task25/components/backgroundCompoenent.dart';

import '../home/userData.dart';

class Join extends StatefulWidget {
  Join({required this.phNumber, required this.VerificationId, Key? key})
      : super(key: key);
  String phNumber, VerificationId;
  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  final _formPhoneKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController otp = TextEditingController();
  var givenBlue = const Color(0xFF314b5c);
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
        body: Stack(
          children: <Widget>[
            backgroundImg(h: h),
            Positioned(
                top: 30,
                left: 10,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                )),
            Positioned(
                left: 20,
                right: 20,
                top: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Icons/icon1.png',
                      height: 170,
                      width: 170,
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
                              height: .14 * h,
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: .02 * h, bottom: .02 * h),
                                      width: .8 * w,
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
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: .03 * w,
                                          ),
                                          const Icon(
                                              Icons.phone_android_rounded,
                                              size: 30,
                                              color: Colors.black),
                                          SizedBox(
                                            width: .07 * w,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (widget.phNumber == "") {
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Text(
                                              widget.phNumber != ""
                                                  ? widget.phNumber
                                                  : "Enter Phone Number",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: .01 * h,
                            ),
                            const Text(
                              "- OTP -",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: .02 * h,
                            ),
                            const Text(
                              "ENTER OTP SEND TO YOUR PHONE NUMBER",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: .02 * h,
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 0, 25, 0),
                                child: PinCodeTextField(
                                  pastedTextStyle: TextStyle(color: givenBlue),
                                  blinkWhenObscuring: true,
                                  appContext: context,
                                  length: 6,
                                  cursorWidth: 2.0,
                                  enableActiveFill: true,
                                  pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      activeFillColor: Colors.white,
                                      activeColor: Colors.white,
                                      selectedFillColor: Colors.white,
                                      selectedColor: Colors.white,
                                      inactiveFillColor: Colors.white,
                                      inactiveColor: Colors.white,
                                      fieldHeight: 40,
                                      borderWidth: 3.0),
                                  keyboardType: TextInputType.number,
                                  boxShadows: const [
                                    BoxShadow(
                                        offset: Offset(.4, .4),
                                        color: Colors.black,
                                        blurRadius: 5,
                                        spreadRadius: 1)
                                  ],
                                  controller: otp,
                                  cursorColor: Colors.black,
                                  onChanged: (String value) {},
                                )),
                            SizedBox(
                              height: .02 * h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Didn't received OTP?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                                TextButton(
                                    onPressed: () {},
                                    child: const Text("Resend",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Colors.blue)))
                              ],
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
                                  verifyOTP(widget.VerificationId, otp.text);
                                },
                                child: Container(
                                  width: .39 * w,
                                  height: h * .06,
                                  padding: EdgeInsets.all(5.0),
                                  child: const Center(
                                    child: Text("LOGIN",
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
                )),
          ],
        ),
      ),
    );
  }

  void verifyOTP(String verificationId, String otp) async {
    print(verificationId);
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);

    await auth.signInWithCredential(credential).then((value) async {
      if (value.user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => userData()),
            (route) => false);
      }
      print("You are logged in successfully");
      Fluttertoast.showToast(
          msg: "You are logged in successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.lightGreenAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }
}
