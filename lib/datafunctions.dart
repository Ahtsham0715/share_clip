import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_clip/custom%20widgets/custom_toast.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';

var dbref = FirebaseFirestore.instance;
var currentuser = FirebaseAuth.instance.currentUser;
final box = GetStorage();
var previousclipdata;

// var getclipboard = Clipboard.getData('text/plain').then((value) {
//   previousclipdata = value!.text;
// });
Timer? timer;
void setclipboard(data, {required showsnackbar}) {
  Clipboard.setData(ClipboardData(text: data)).then((value) {
    showsnackbar ? styledsnackbar(txt: 'Copied to clipboard', icon: Icons.copy): null;
  });
}

Future readdeviceinfo() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  final devicedata = deviceInfo.toMap();
  // print(devicedata);
  return devicedata;
}

Future autosync() async {
  print(previousclipdata);
  timer = Timer.periodic(Duration(seconds: 2), (timer) async {
    var getclipboard = await Clipboard.getData('text/plain');
    if (previousclipdata != getclipboard!.text) {
      previousclipdata = getclipboard.text;
      SyncData(isautosync: true);
    }
  });
}

Future SyncData({required isautosync}) async {
  !isautosync
      ? customdialogcircularprogressindicator('Syncing Data... ')
      : null;
  DateTime now = DateTime.now();
  var formattedDate = DateFormat('MMM dd yyyy\nhh:mm a').format(now); //kk:mm:ss
  var getclipboard = await Clipboard.getData('text/plain');
  print(getclipboard?.text);

  await dbref
      .collection('clipboarddata')
      .doc(currentuser!.uid)
      .collection('userclipdata')
      .where('clipboard_data', isEqualTo: getclipboard!.text)
      .get()
      .then((QuerySnapshot data) {
    if (data.docs.isEmpty) {
      try {
        dbref
            .collection('clipboarddata')
            .doc(currentuser!.uid)
            .collection('userclipdata')
            .doc()
            .set({
          'isPinned': false,
          'date': formattedDate,
          'clipboard_data': getclipboard.text,
        }, SetOptions(merge: true));
        setclipboard(getclipboard.text, showsnackbar: false);
        !isautosync ? Get.back() : null;
        !isautosync ? styledsnackbar(
              txt: 'Data Synced Successfully', icon: Icons.sync_alt): null;
      } on FirebaseException catch (e) {
        print('error occured .$e');
        if (!isautosync) {
          Get.back();
          styledsnackbar(
              txt: 'Data Sync Failed', icon: Icons.sms_failed_outlined);
        }
      }
    } else {
      if (!isautosync) {
        Get.back();
        styledsnackbar(
            txt: 'Data Already Found', icon: Icons.sms_failed_outlined);
      }
    }
  });
}

Future pintoggle({required docid, required ispinned}) async {
  // ispinned ?
  // customdialogcircularprogressindicator('Pinning... '):
  // customdialogcircularprogressindicator('UnPinning... ');
  try {
    await dbref
        .collection('clipboarddata')
        .doc(currentuser!.uid)
        .collection('userclipdata')
        .doc(docid)
        .set({
      'isPinned': ispinned,
    }, SetOptions(merge: true));
    // Get.back();
  } on FirebaseException catch (e) {
    print('error occured .$e');
    // Get.back();
  }
}

Future deletedata({required docid}) async {
  customdialogcircularprogressindicator('Deleting... ');
  try {
    await dbref
        .collection('clipboarddata')
        .doc(currentuser!.uid)
        .collection('userclipdata')
        .doc(docid)
        .delete();
    Get.back();
  } on FirebaseException catch (e) {
    print('error occured .$e');
    Get.back();
  }
}


Future GetDevices() async {
  List connectedDevices = [];
  await dbref
      .collection('connected_devices')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((DocumentSnapshot mydevices) {
    if (mydevices.exists) {
      connectedDevices = mydevices['devices'];
    }
  });
  print(connectedDevices);
  return connectedDevices;
}

Future editDeviceName({required updatedName, required deviceid}) async {
  List devices = [];
  List updateddeviceslist = [];
  await FirebaseFirestore.instance
      .collection('connected_devices')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((DocumentSnapshot mydevices) {
    if (mydevices.exists) {
      devices = mydevices['devices'];
    }
    for (var device in devices) {
      if (device['device_id'] != deviceid) {
        updateddeviceslist.add({
          'device_id': device['device_id'], //QP1A.190711.020
          'device_name': device['device_name'],
        });
      } else {
        updateddeviceslist.add({
          'device_id': device['device_id'], //QP1A.190711.020
          'device_name': updatedName,
        });
      }
    }
  });
  try {
    await FirebaseFirestore.instance
        .collection('connected_devices')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'devices': updateddeviceslist,
    }, SetOptions(merge: true));
  } on FirebaseException catch (e) {
    customtoast('unable to edit device name');
  } on PlatformException catch (e) {
    customtoast('unable to edit device name');
  }
}

Future<void> uploadFile(String filePath) async {
    customdialogcircularprogressindicator('Uploading... ');
    File file = File(filePath);
    var filename = filePath.toString().split('/').last;
    try {
      await FirebaseStorage.instance
          .ref('${currentuser!.uid}/${filename}')
          .putFile(file);
          downloadURLfunc(filename);
    } on FirebaseException catch (e) {
      Get.snackbar('Error occured while uploading the file', '$e');
    }
  }

  Future<void> downloadURLfunc(fname) async {
    try{
      String fileurl = await FirebaseStorage.instance
        .ref('${currentuser!.uid}/${fname}')
        .getDownloadURL();
      sendfiles(link: fileurl, filename: fname);
    }on FirebaseException catch(e){
      Get.snackbar('Error occured while downloading the file', '$e');
    }
    
  }

Future sendfiles({required link, required filename}) async {
  DateTime now = DateTime.now();
  var formattedDate = DateFormat('MMM dd yyyy\nhh:mm a').format(now); //kk:mm:ss
  try {
    dbref
        .collection('sharedfiles')
        .doc(currentuser!.uid)
        .collection('userfiles')
        .doc()
        .set({
          'date': formattedDate,
          'filelink': link,
          'filename': filename
        }, SetOptions(merge: true));
        Get.back();
  } on FirebaseException catch (e) {
    Get.snackbar('Error occured while downloading the file', '$e');
  }
}

Future deletefile({required docid, required url}) async {
  customdialogcircularprogressindicator('Deleting... ');
  try {
    await FirebaseStorage.instance.refFromURL(url).delete();
    await dbref
        .collection('sharedfiles')
        .doc(currentuser!.uid)
        .collection('userfiles')
        .doc(docid)
        .delete();
    Get.back();
  } on FirebaseException catch (e) {
    print('error occured .$e');
    Get.back();
  }
}

Future permissionmanager() async {
    if (await Permission.storage.status.isDenied) {
      await Permission.storage.request();
      // Either the permission was already granted before or the user just granted it.
    }
  }

Future downloadfile({required ctx, required fileurl, required filename}) async {
    permissionmanager();
    customdialogcircularprogressindicator('Downloading...');
    // var ref = await FirebaseStorage.instance
    //     .ref()
    //     .child("images")
    //     .child('file_template')
    //     .child('template.xlsx')
    //     .getDownloadURL();
    print(fileurl);
    // print(await getTemporaryDirectory());
    var externalStorageDirPath;
    // final directory = await getExternalStorageDirectory();
    Directory directory = Directory('/storage/emulated/0/Download');
    directory.create();
    directory.createSync();
    externalStorageDirPath = directory.path + '/' + filename.toString();
    Dio dio = Dio();
    final response = await dio.download(fileurl, externalStorageDirPath,
        onReceiveProgress: ((rec, total) {
      print('rec: $rec  total:$total');
    }));
    Navigator.pop(ctx);
    styledsnackbar(txt: 'File downloaded to\n$externalStorageDirPath', icon: Icons.download_done);
  }

  Future autorun() async {
    if(box.read('autosync')){
      final service = FlutterBackgroundService();
      service.startService();
      // service.invoke();
      autosync();
    }
  }

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: (serviceinstance){
        // autorun();
      },
      foregroundServiceNotificationTitle: 'ShareClip',
      foregroundServiceNotificationContent: 'Sync latest clipboard data across connected devices',
      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: (sinstance){},

      // you have to enable background fetch capability on xcode project
      onBackground: (sinstance){
        return false;
      },
    ),
  );
  // service.startService();
}

//   Future<Null> urlFileShare({required context, required url}) async {
//   final RenderBox box = context.findRenderObject();
//   if (Platform.isAndroid) {
//     // var url = 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg';
//     var response = await get(Uri.parse(url));
//     final documentDirectory = await getExternalStorageDirectory();
//     File imgFile = new File('$documentDirectory/flutter.png');
//     imgFile.writeAsBytesSync(response.bodyBytes);
// Share.shareFile(File('$documentDirectory/flutter.png'),
//         subject: 'URL File Share',
//         text: 'Hello, check your share files!',
//         sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
//   } else {
//     Share.share('Hello, check your share files!',
//         subject: 'URL File Share',
//         sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
//   }

// }