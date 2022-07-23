import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:share_clip/custom%20widgets/custom_toast.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';
import 'package:share_clip/settings.dart';
import 'package:share_clip/signin.dart';
import 'package:share_clip/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  GoogleSignIn googleSignin = GoogleSignIn();
  User? currentuser = FirebaseAuth.instance.currentUser;
  late TabController _tabController;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController devicecontroller = TextEditingController();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  DateTime now = DateTime.now();
  String? formattedDate;
  bool darkmode = false;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    formattedDate = DateFormat('EEE d MMM').format(now); //kk:mm:ss
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    readdeviceinfo();
    super.initState();
    _tabController.addListener(() {
      setState(() {});
    });
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Get.to(
          () => const SigninPage(),
        );
      }
    });
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      styledsnackbar(txt: "You are online now");
    } else {
      styledsnackbar(txt: 'You are currently offline');
    }
  }

  Future readdeviceinfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final devicedata = deviceInfo.toMap();
    print(devicedata);
    return devicedata;
  }

  Future deletedevice() async {
    List devices = [];
    List updateddeviceslist = [];
    var thisdevice;
    readdeviceinfo().then((value) => thisdevice = value);
    await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('connected_devices')
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
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc('connected_devices')
          .set({
        'devices': updateddeviceslist,
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      customtoast('unable to delete device');
    }
  }

  Widget customdailog(
    title,
    textfeild1,
    onpressed,
    button,
  ) {
    return AlertDialog(
      backgroundColor: customPrimaryColor,
      title: Center(child: customText(txt: title, fweight: FontWeight.w500)),
      actions: [
        textfeild1,
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL')),
            MaterialButton(onPressed: onpressed, child: Text(button)),
          ],
        ),
      ],
    );
  }

  Widget customtextformfield(
    icon, {
    initialvalue,
    hinttext,
    controller,
    validator,
    onsaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 19, right: 19, bottom: 10),
      child: Form(
        key: _formkey,
        child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            validator: validator,
            onSaved: onsaved,
            readOnly: false,
            initialValue: initialvalue,
            cursorColor: Colors.teal,
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colors.white,
              ),
              hintText: hinttext,
              labelStyle: const TextStyle(
                color: Colors.teal,
              ),
              filled: true,
              // enabled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: const BorderSide(color: Colors.teal),
              ),
            )),
      ),
    );
  }

  Future custombottomsheet() async {
    showModalBottomSheet(
      backgroundColor: customPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, innersetState) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: customText(
                    txt: 'Connected Devices',
                    padding: 15.0,
                    fsize: 20.0,
                    fweight: FontWeight.w500),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        title: customText(
                            txt: 'Device ${index + 1}',
                            fsize: 20.0,
                            fweight: FontWeight.w400),
                        trailing: IconButton(
                          onPressed: () {
                            devicecontroller.text = 'Device ${index + 1}';
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return customdailog(
                                      'Edit Device Name',
                                      customtextformfield(
                                        Icons.edit,
                                        hinttext: 'Device Name',
                                        controller: devicecontroller,
                                        onsaved: (value) {
                                          devicecontroller.text = value!;
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please Enter Device Name ";
                                          }
                                        },
                                      ), () {
                                    if (_formkey.currentState!.validate()) {}
                                  }, 'SUBMIT');
                                });
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 22.0,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return onWillPop(context);
      },
      child: Scaffold(
        // backgroundColor: customPrimaryColor,
        floatingActionButton: _tabController.index == 1
            ? FloatingActionButton.extended(
                backgroundColor: Colors.teal,
                onPressed: () {},
                label: customText(
                    txt: ' File ',
                    fsize: 18.0,
                    // fweight: FontWeight.w300,
                    clr: Colors.white),
                icon: const Icon(
                  Icons.add,
                  size: 25.0,
                  color: Colors.white,
                ),
              )
            : null,
        drawer: Drawer(
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
                  Get.to(
                    () => const SettingsPage(),
                  );
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
        ),
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  title: customText(
                      txt: 'ShareClip', fsize: 22.0, fweight: FontWeight.w500),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  backgroundColor: const Color.fromARGB(255, 35, 54, 65),
                  pinned: true,
                  floating: true,
                  snap: true,
                  centerTitle: true,
                  expandedHeight: responsiveHW(context, ht: 12),
                  collapsedHeight: responsiveHW(context, ht: 11),
                  flexibleSpace: const FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          custombottomsheet();
                        },
                        icon: const Icon(
                          Icons.devices_other,
                          size: 28.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  bottom: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.blueGrey,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 3.0,
                    labelColor: Colors.teal,
                    unselectedLabelColor:
                        const Color.fromARGB(255, 190, 189, 192),
                    tabs: const [
                      Tab(
                        text: "Clipboard",
                        icon: Icon(FontAwesomeIcons.clipboardCheck),
                      ),
                      Tab(
                        text: "Files",
                        icon: Icon(FontAwesomeIcons.solidFileLines),
                      ),
                      Tab(
                        text: "Pinned",
                        icon: Icon(Icons.push_pin_sharp),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 19, right: 19, top: 13),
                        child: Container(
                          // height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: const Color.fromARGB(255, 20, 35, 43),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                // isThreeLine: true,
                                // dense: false,
                                title: const Text(
                                  'clipboard data\nhdjsfsddsf\nasjdsja\nsgahd\nsdndjdsfds\nkjsdfj',
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    color: Colors.white,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: customText(
                                    txt: formattedDate, clr: Colors.white),
                              ),
                              ListTile(
                                minVerticalPadding: 0.0,
                                leading: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Icon(
                                    Icons.device_unknown,
                                    color: Colors.white,
                                  ),
                                ),
                                title: ButtonBar(
                                  alignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      // splashColor: Colors.white,
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.copy_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.push_pin_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // 2nd tab
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
                // 3rd tab
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
