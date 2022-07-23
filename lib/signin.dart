import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  Future signInWithGoogle() async {
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

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        isworking = false;
      });
      customtoast('Login Successful');
      Get.to(
        () => const HomePage(),
        transition: Transition.rightToLeftWithFade,
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      customtoast('Unable to login');
      setState(() {
        isworking = false;
      });
    }
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
                  backgroundColor:
                      MaterialStateProperty.all(Colors.teal.withAlpha(100)),
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
