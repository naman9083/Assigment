import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:task25/views/home/home.dart';

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class userData extends StatefulWidget {
  const userData({Key? key}) : super(key: key);

  @override
  State<userData> createState() => _userDataState();
}

class _userDataState extends State<userData> {
  String? _currentAddress;
  Position? _currentPosition;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Reference? storageReference;
  CollectionReference users = FirebaseFirestore.instance.collection("userData");
  XFile? file;
  String? url;
  String time = "";
  File? imgfile;
  final TextEditingController _text = TextEditingController();
  final TextEditingController phone = TextEditingController();
  dynamic data;
  String? uid;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  imagePick() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera)
        .then((value) => setState(() {
              file = value;
              imgfile = File(file!.path);
              storageReference =
                  firebaseStorage.ref().child("images/${file!.name}");
              UploadTask uploadTask = storageReference!.putFile(imgfile!);
              uploadTask.then((res) {
                res.ref.getDownloadURL().then((value) {
                  print(value);
                  setState(() {
                    url = value;
                  });
                });
              });
            }));
  }

  void createUserInFirestore() {
    users.doc(FirebaseAuth.instance.currentUser!.uid).set({
      "name": _text.text,
      "phone": FirebaseAuth.instance.currentUser!.phoneNumber,
      "address": _currentAddress,
      "image": url,
      "time": time
    });
  }

  setTime() {
    DateTime now = DateTime.now();
    setState(() {
      time = now.toString().substring(0, 16);
    });
  }

  getData() async {
    uid = auth.currentUser!.uid;
    data = await users.doc(uid).get();
    setState(() {
      _text.text = data['name'];
      phone.text = data['phone'];
      _currentAddress = data['address'];
      url = data['image'];
      time = data['time'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentPosition();
    setTime();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: url == null
                          ? const AssetImage("assets/Icons/icon1.png")
                          : NetworkImage(url!) as ImageProvider,
                    ),
                  ),
                ),
                Container(
                  child: InkWell(
                    onTap: () {
                      imagePick();
                    },
                    child: const Text(
                      'Change Profile Picture',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: TextField(
                    controller: _text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.2),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      hintText: 'Enter your name',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text(
                    _currentAddress == null
                        ? 'Loading...'
                        : "Current Location: $_currentAddress",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text(
                    "Joined: On ${time.substring(0, 10)} at ${time.substring(11, 16)}" ??
                        '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      onPressed: () {
                        if (_text.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Please enter your name",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if (url == null) {
                          Fluttertoast.showToast(
                              msg: "Please wait for image to upload",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          createUserInFirestore();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Home(),
                            ),
                          );
                        }
                      },
                      child: const Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      )),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
