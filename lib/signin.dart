import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';
import 'package:share_clip/home_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                backgroundColor: MaterialStateProperty.all(Colors.teal),
              ),
              onPressed: () {
                Get.to(
                  () => const HomePage(),
                );
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
                      txt: 'Signin with Google',
                      fsize: 20.0,
                      fweight: FontWeight.w500,
                      clr: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
