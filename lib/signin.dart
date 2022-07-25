import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_clip/custom%20widgets/custom_toast.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';
import 'package:share_clip/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool isworking = false;

  @override
  void initState() {
    super.initState();
    readdeviceinfo();
  }

  Future readdeviceinfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final devicedata = deviceInfo.toMap();
    print(devicedata);
    return devicedata;
  }

  Future setdeviceinfo() async {
    var deviceData;
    await readdeviceinfo().then((value) {
      deviceData = value;
    });
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc('connected_devices')
          .set({
        'devices': FieldValue.arrayUnion([
          {
            'device_id': deviceData['id'], //QP1A.190711.020
            'device_name': deviceData['model'],
          }
        ]),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      customtoast('Error Saving Data');
    }
  }

  Future signInWithGoogle() async {
    
    try {
      // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
      await FirebaseAuth.instance.signInWithCredential(credential);
      await setdeviceinfo();
      setState(() {
        isworking = false;
      });
      customtoast('Login Successful');
      Get.to(
        () => const HomePage(),
        transition: Transition.rightToLeftWithFade,
        duration: const Duration(seconds: 1),
      );
    } on FirebaseAuthException catch (e) {
      customtoast('Unable to login');
      setState(() {
        isworking = false;
      });
    } on FirebaseException catch(e){
      customtoast('Error Occured');
      setState(() {
        isworking = false;
      });
    } on PlatformException catch(e){
      customtoast('Error Occured. Try again $e');
      setState(() {
        isworking = false;
      });
    }
    // setState(() {
    //   isworking = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return onWillPop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          title: customText(
            txt: 'SignIn',
            fsize: 22.0,
            fweight: FontWeight.w500,
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Image.asset(
              'assets/images/signin.png',
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(10.0),
                  ),
                  shape: MaterialStateProperty.all(
                    const StadiumBorder(),
                  ),
                  backgroundColor: MaterialStateProperty.all(!isworking
                      ? Colors.teal.withAlpha(100)
                      : Colors.grey.withAlpha(100)),
                ),
                onPressed: isworking
                    ? null
                    : () {
                        setState(() {
                          isworking = true;
                        });
                        // Get.to(
                        //   () => const HomePage(),
                        // );
                        signInWithGoogle().then((value) {
                          print(value);
                        });
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/images/google.png',
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    customText(
                        txt: 'Continue with Google',
                        fsize: 20.0,
                        fweight: FontWeight.w500,
                        clr: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
