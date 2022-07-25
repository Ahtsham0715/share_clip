import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

var dbref = FirebaseFirestore.instance;
var currentuser = FirebaseAuth.instance.currentUser;

Future SyncData() async {}

Future GetDevices() async {
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
