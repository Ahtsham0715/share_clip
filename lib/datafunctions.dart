import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:share_clip/custom%20widgets/custom_toast.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';

var dbref = FirebaseFirestore.instance;
var currentuser = FirebaseAuth.instance.currentUser;
final box = GetStorage();
var previousclipdata;

var getclipboard = Clipboard.getData('text/plain').then((value) {
  previousclipdata = value!.text;
});
Timer? timer;
void setclipboard(data) {
  Clipboard.setData(ClipboardData(text: data)).then((value) {
    styledsnackbar(txt: 'Copied to clipboard', icon: Icons.copy);
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
      .where('clipboard_data', isEqualTo: getclipboard?.text)
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
          'clipboard_data': getclipboard!.text,
        }, SetOptions(merge: true));
        setclipboard(getclipboard.text);
        !isautosync ? Get.back() : null;
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