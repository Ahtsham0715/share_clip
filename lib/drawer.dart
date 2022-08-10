
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:share_clip/custom%20widgets/custom_toast.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';
import 'package:share_clip/datafunctions.dart';
import 'package:share_clip/settings.dart';

 Future deletedevice() async {
    List devices = [];
    List updateddeviceslist = [];
    var thisdevice;
    readdeviceinfo().then((value) => thisdevice = value);
    await FirebaseFirestore.instance
          .collection('connected_devices')
          .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot mydevices) {
      if (mydevices.exists) {
        devices = mydevices['devices'];
      }
      for (var device in devices) {
        if (device['device_id'] != thisdevice['id']) {
          updateddeviceslist.add({
            'device_id': device['device_id'], //QP1A.190711.020
            'device_name': device['device_name'],
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
      customtoast('unable to delete device');
    }
  }

Widget mydrawer({required context}) {
  return Drawer(
          backgroundColor: customPrimaryColor,
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: customPrimaryColor,
                ),
                accountName:
                    customText(txt: currentuser?.displayName.toString()),
                accountEmail: customText(txt: currentuser?.email.toString()),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.grey,
                  foregroundImage:
                      CachedNetworkImageProvider('${currentuser?.photoURL}'),
                  child: const Icon(
                    Icons.person,
                    size: 50.0,
                    color: Colors.white60,
                  ),
                ),
              ),
              // customdivider(),
              ListTile(
                dense: true,
                onTap: () {
                  Get.to(() => const SettingsPage(),
                      transition: Transition.noTransition);
                },
                title: customText(
                  txt: 'Settings',
                  fsize: 18.0,
                  fweight: FontWeight.w500,
                ),
                leading: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
              // customdivider(),
              // SwitchListTile(
              //   dense: true,
              //   title: customText(
              //     txt: 'Dark Mode',
              //     fsize: 18.0,
              //     fweight: FontWeight.w500,
              //   ),
              //   secondary: const Icon(
              //     Icons.dark_mode,
              //     color: Colors.white,
              //   ),
              //   value: darkmode,
              //   onChanged: (val) {
              //     setState(() {
              //       darkmode = val;
              //     });
              //   },
              // ),
              customdivider(),
              ListTile(
                dense: true,
                onTap: () {
                  customYesNoDialog(
                      ctx: context,
                      titletext: 'Are you sure?',
                      contenttext: 'Do you want to Logout?',
                      yesOnTap: () async {
                        Navigator.pop(context);
                        customdialogcircularprogressindicator(
                            'Logging out... ');
                        try {
                          await deletedevice().then((value) {
                            GoogleSignIn().disconnect();
                            FirebaseAuth.instance.signOut();
                            Navigator.pop(context);
                          });

                          customtoast('User logged out');
                        } catch (e) {
                          Navigator.pop(context);
                          customtoast('Error while signing out');
                        }
                      });
                },
                title: customText(
                  txt: 'Logout',
                  fsize: 18.0,
                  fweight: FontWeight.w500,
                ),
                leading: const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
}

