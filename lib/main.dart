import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';
import 'package:share_clip/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      //   primarySwatch: Colors.blue,
      //   primaryColor: customPrimaryColor,
      // ),
      theme: ThemeData.dark().copyWith(
          primaryColor: customPrimaryColor,
          scaffoldBackgroundColor: customPrimaryColor,
          colorScheme: ColorScheme.light(
            tertiary: customPrimaryColor,
            // brightness: Brightness.light,
            primary: customPrimaryColor,
          )),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}
