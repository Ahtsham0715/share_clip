import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';
import 'package:share_clip/notifications.dart';
import 'package:share_clip/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/app_icon',
      // null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'shareclip_channel',
            channelName: 'shareclip notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: customPrimaryColor,
            // channelShowBadge: false,
            // defaultRingtoneType: DefaultRingtoneType.Notification,
            locked: true,
            importance: NotificationImportance.Max,
            playSound: false,
            defaultPrivacy: NotificationPrivacy.Public,
            enableVibration: false,
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AwesomeNotifications()
    //     .actionStream
    //     .listen((ReceivedNotification receivedNotification) {
    //   // Navigator.of(context).pushNamed('/NotificationPage', arguments: {
    //   //   // your page params. I recommend you to pass the
    //   //   // entire *receivedNotification* object
    //   //   receivedNotification.id
    //   // });
    // });
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
