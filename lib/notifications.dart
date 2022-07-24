// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:workmanager/workmanager.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';

Future shownotification() async {
  AwesomeNotifications().cancelAll();

  AwesomeNotifications().createNotification(
      content: NotificationContent(
          notificationLayout: NotificationLayout.Default,
          payload: {'sendbtn': 'Send'},
          backgroundColor: customPrimaryColor,
          category: NotificationCategory.Service,
          color: customPrimaryColor,
          autoDismissible: false,
          displayOnBackground: true,
          displayOnForeground: true,
          locked: true,
          // largeIcon: 'asset://assets/images/splash.png',
          // roundedLargeIcon: true,
          // bigPicture: 'asset://assets/images/google.png',
          // wakeUpScreen: true,
          id: 1,
          channelKey: 'shareclip_channel',
          title: 'Sync Data',
          body: 'Sync latest clipboard data across connected devices'),
      actionButtons: [
        NotificationActionButton(
          key: 'sendbtn',
          label: 'Send',
          autoDismissible: false,
          buttonType: ActionButtonType.Default,
          color: const Color.fromARGB(255, 2, 165, 149),
          enabled: true,
          // showInCompactView: false,
          icon: 'resource://drawable/google.png',
        )
      ]);
}
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) {
//     // initialise the plugin of flutterlocalnotifications.
//     FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

//     // app_icon needs to be a added as a drawable
//     // resource to the Android head project.
//     var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
//     // var IOS = const IOSInitializationSettings();

//     // initialise settings for both Android and iOS device.
//     var settings = InitializationSettings(android: android);
//     flip.initialize(settings);
//     showNotificationWithDefaultSound(flip);
//     return Future.value(true);
//   });
// }

// Future showNotificationWithDefaultSound(flip) async {
//   // Show a notification after every 15 minute with the first
//   // appearance happening a minute after invoking the method
//   var androidPlatformChannelSpecifics =
//       const AndroidNotificationDetails('your channel id', 'your channel name',
//           // 'your channel description',
//           importance: Importance.max,
//           priority: Priority.high,
//           ongoing: true,
//           channelShowBadge: true,
//           enableLights: true,
//           fullScreenIntent: true,
//           playSound: false,
//           channelAction: AndroidNotificationChannelAction.createIfNotExists,
//           visibility: NotificationVisibility.public);
//   // var iOSPlatformChannelSpecifics = IOSNotificationDetails();

//   // initialise channel platform for both Android and iOS device.
//   var platformChannelSpecifics = NotificationDetails(
//     android: androidPlatformChannelSpecifics,
//     // iOS: iOSPlatformChannelSpecifics
//   );
//   await flip.show(
//     0,
//     'Sync Data',
//     'Sync latest clipboard data across connected devices',
//     platformChannelSpecifics,
//     // payload: 'Default_Sound',
//   );
// }
