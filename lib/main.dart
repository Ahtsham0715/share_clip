import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';
import 'package:share_clip/notifications.dart';
import 'package:share_clip/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(

      // The top level function, aka callbackDispatcher
      callbackDispatcher,

      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: true);
  // Periodic task registration
  Workmanager().registerPeriodicTask(
    "2",

    //This is the value that will be
    // returned in the callbackDispatcher
    "simplePeriodicTask",

    // When no frequency is provided
    // the default 15 minutes is set.
    // Minimum frequency is 15 min.
    // Android will automatically change
    // your frequency to 15 min
    // if you have configured a lower frequency.
    frequency: const Duration(minutes: 15),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
