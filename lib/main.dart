import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';
import 'package:share_clip/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          primaryColor: customPrimaryColor,
          scaffoldBackgroundColor: customPrimaryColor,
          colorScheme: ColorScheme.light(
            tertiary: customPrimaryColor,

            // brightness: Brightness.light,
            primary: customPrimaryColor,
          )),
      themeMode: ThemeMode.dark,
      home: const SplashScreen(),
    );
  }
}
