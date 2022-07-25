import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_clip/custom%20widgets/custom_toast.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';

var dbref = FirebaseFirestore.instance;
var currentuser = FirebaseAuth.instance.currentUser;


void setclipboard(data) {
  Clipboard.setData(ClipboardData(text: data));
}

Future readdeviceinfo() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  final devicedata = deviceInfo.toMap();
  // print(devicedata);
  return devicedata;
}

Future SyncData() async {
  
 DateTime now = DateTime.now();
var formattedDate = DateFormat('MMM dd yyyy\nhh:mm a').format(now); //kk:mm:ss
  var getclipboard = await Clipboard.getData('text/plain');
print(getclipboard?.text);
try{
 dbref
      .collection('clipboarddata')
      .doc(currentuser!.uid)
      .set({
       'data' : [
        {
          'date': formattedDate,
          'clipboard_data' : getclipboard!.text
        }
       ]
      }, SetOptions(merge: true));
}on FirebaseException catch(e){
print('error occured .$e');
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
