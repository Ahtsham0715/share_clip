import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:share_clip/home_page.dart';
import 'package:share_clip/signin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    super.initState();
    initTimer();
  }

//  @override
//   void dispose() {
//     _connectivitySubscription.cancel();
//     super.dispose();
//   }

  Future<bool> CheckConnection() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
      //  var connectivityResult = await (Connectivity().checkConnectivity());
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        print('connection available');
        return true;
      } else {
        print('connection unavailable');
        return false;
      }
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status error: $e');
      print('connection unavailable');
      return false;
    }
  }

  Future<void> initTimer() async {
    if (await CheckConnection()) {
      Timer(const Duration(seconds: 1), () async {
        if (await GoogleSignIn().isSignedIn() ||
            FirebaseAuth.instance.currentUser != null) {
          // pehly != tha
          Get.to(
            () => const HomePage(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(seconds: 1),
          );
        } else {
          Get.to(
            () => const SigninPage(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(seconds: 1),
          );
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            WillPopScope(onWillPop: () async => false, child: customAlert()),
        barrierDismissible: false,
      );
      //  customAlert();
    }
  }

  Widget customAlert() {
    // SplashWidget().showSplashLogo();
    return AlertDialog(
      insetPadding: const EdgeInsets.all(10.0),
      actionsPadding: const EdgeInsets.only(bottom: 10.0),
      title: Icon(
        CupertinoIcons.exclamationmark_circle_fill,
        color: Colors.red[400],
        size: 70.0,
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: const Text(
          'No internet available! Please\n reconnect and try again',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18.0,
              // color: Colors.black,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0),
        ),
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () async {
              SystemNavigator.pop();
            },
            style: TextButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width * 0.7,
                  MediaQuery.of(context).size.height * 0.06),
              maximumSize: Size(MediaQuery.of(context).size.width * 0.75,
                  MediaQuery.of(context).size.height * 0.06),
              primary: Colors.black,
              backgroundColor: Colors.grey[350],
              elevation: 2.0,
              textStyle: const TextStyle(
                  fontSize: 20, fontFamily: "Viga", color: Colors.black),
            ),
            child: const Text('ok'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var widthSize = MediaQuery.of(context).size.width;
    var heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        // color: Colors.white,
        width: widthSize,
        height: heightSize,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "ShareClip",
              style: TextStyle(
                fontSize: heightSize * 4 / 100,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Image.asset(
              "assets/images/splash.png",
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),

            // const CircularProgressIndicator(
            //   color: Colors.teal,
            //   strokeWidth: 3.0,
            // ),
            SizedBox(
              height: heightSize * 3 / 100,
            ),
            Text(
              "Share your clipboard with all connected devices",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: heightSize * 3 / 100,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
