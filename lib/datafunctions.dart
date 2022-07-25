
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_clip/custom%20widgets/custom_toast.dart';

var dbref = FirebaseFirestore.instance;
var currentuser = FirebaseAuth.instance.currentUser;

var getclipboard = Clipboard.getData(Clipboard.kTextPlain);
// var history =  Clipboard;
void setclipboard(data) {
  Clipboard.setData(ClipboardData(text: data));
}

Future SyncData() async {}

Future GetDevices() async {
  print('clipboard data:$getclipboard');
  List connectedDevices = [];
  await dbref
      .collection('connected_devices')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((DocumentSnapshot mydevices) {
        if(mydevices.exists){
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
        }else{
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
        'devices':updateddeviceslist,
      }, SetOptions(merge: true));
      Get.back();
      Get.back();
    } on FirebaseException catch (e) {
      customtoast('unable to edit device name');
    } on PlatformException catch(e){
      customtoast('unable to edit device name');
    }
}