import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:share_clip/custom%20widgets/custom_toast.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';
import 'package:share_clip/datafunctions.dart';
import 'package:share_clip/drawer.dart';
import 'package:share_clip/edit_dialog.dart';
import 'package:share_clip/notifications.dart';
import 'package:share_clip/settings.dart';
import 'package:share_clip/signin.dart';
import 'package:share_clip/tabbarviews.dart';
import 'package:share_clip/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  bool isloadingdevices = true;
  List DevicesList = [];
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    formattedDate = DateFormat('MMM dd yyyy\nhh:mm a').format(now); //kk:mm:ss
    readdeviceinfo();
    autocopy();
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
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    if (box.read('autosync')) {
      autosync();
    }
    GetDevices().then((value) {
      DevicesList = value;
      setState(() {
        isloadingdevices = false;
      });
    });
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    // autorun();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(updateConnectionStatus);
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
                onPressed: () {
                  filepicker(filetype: FileType.any).then((value) {
                    if (value != null) {
                      uploadFile(value.toString());
                    }
                  });
                },
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
        drawer: mydrawer(context: context),
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
                      padding: isloadingdevices
                          ? const EdgeInsets.all(10.0)
                          : const EdgeInsets.all(8.0),
                      child: isloadingdevices
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                custombottomsheet(
                                        context: context,
                                        deviceslist: DevicesList)
                                    .then((value) {
                                  GetDevices().then((value) {
                                    DevicesList = value;

                                    setState(() {
                                      // isloadingdevices = false;
                                    });
                                  });
                                });
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
            body: StreamBuilder<QuerySnapshot>(
                stream: dbref
                    .collection('clipboarddata')
                    .doc(currentuser!.uid)
                    .collection('userclipdata')
                    .orderBy('createdAt', descending: true)
                    // .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  var data = snapshot.data!.docs;
                  var unpinnedlist = data.where((element) {
                    return element
                        .get('isPinned')
                        .toString()
                        .toLowerCase()
                        .contains('false');
                  }).toList();
                  var pinnedlist = data.where((element) {
                    return element
                        .get('isPinned')
                        .toString()
                        .toLowerCase()
                        .contains('true');
                  }).toList();
                  if (snapshot.hasError) {
                    // print(snapshot.error);
                    return const Center(
                      child: Text('Something Went Wrong'),
                    );
                  }
                  if (!snapshot.hasData) {
                    // print(snapshot.error);
                    return const Center(
                      child: Text('No Data Available'),
                    );
                  }
                  // if (snapshot.connectionState == ConnectionState.waiting) {
                  //   return const Center(
                  //     child: CircularProgressIndicator(
                  //       color: Colors.teal,
                  //     ),
                  //   );
                  // }
                  if (data.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          _tabController.index == 0
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(12.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    tileColor: Colors.teal.withAlpha(100),
                                    // isThreeLine: true,
                                    // dense: false,
                                    subtitle: const Text(
                                      'Sync latest clipboard data across connected devices',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      onPressed: () {
                                        // shownotification();
                                        SyncData(isautosync: false);
                                      },
                                      color: Colors.teal,
                                      child: customText(
                                          txt: 'Sync', clr: Colors.white),
                                    ),
                                  ),
                                )
                              : Center(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                          ),
                          Icon(
                            Icons.hourglass_empty,
                            size: 50.0,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'No Data Available',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              // color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        RefreshIndicator(
                            child: tab1view(
                                context: context, datalist: unpinnedlist),
                            backgroundColor: Colors.white,
                            color: Colors.teal,
                            onRefresh: () async {
                              setState(() {});
                            }),
                        // 2nd tab
                        StreamBuilder<QuerySnapshot>(
                            stream: dbref
                                .collection('sharedfiles')
                                .doc(currentuser!.uid)
                                .collection('userfiles')
                                .snapshots(),
                            builder: (context, snapshot) {
                              var filedata = snapshot.data?.docs;
                              if (snapshot.hasError) {
                                // print(snapshot.error);
                                return const Center(
                                  child: Text('Something Went Wrong'),
                                );
                              }
                              if (!snapshot.hasData) {
                                // print(snapshot.error);
                                return const Center(
                                  child: Text('No File Available'),
                                );
                              }
                              // if (snapshot.connectionState == ConnectionState.waiting) {
                              //   return const Center(
                              //     child: CircularProgressIndicator(
                              //       color: Colors.teal,
                              //     ),
                              //   );
                              // }
                              if (filedata!.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Center(),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                      ),
                                      Icon(
                                        Icons.hourglass_empty,
                                        size: 50.0,
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'No File Available',
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                          // color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return RefreshIndicator(
                                    child: tab2view(
                                        context: context, datalist: filedata),
                                    backgroundColor: Colors.white,
                                    color: Colors.teal,
                                    onRefresh: () async {
                                      setState(() {});
                                    });
                              }
                            }),
                        // 3rd tab
                        RefreshIndicator(
                          backgroundColor: Colors.white,
                          color: Colors.teal,
                          child:
                              tab3view(context: context, datalist: pinnedlist),
                          onRefresh: () async {
                            setState(() {});
                          },
                        ),
                      ],
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
