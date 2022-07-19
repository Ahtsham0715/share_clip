import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';
import 'package:share_clip/settings.dart';
import 'package:share_clip/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime now = DateTime.now();
  String? formattedDate;
  bool darkmode = false;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    formattedDate = DateFormat('EEE d MMM').format(now); //kk:mm:ss
    super.initState();
    _tabController.addListener(() {
      setState(() {});
    });
  }

  Future custombottomsheet() async {
    showModalBottomSheet(
      backgroundColor: customPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
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
                        onPressed: () {},
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              accountName: customText(txt: 'Shami'),
              accountEmail: customText(txt: 'abc@gmail.com'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  size: 50.0,
                  color: Colors.white60,
                ),
              ),
            ),
            customdivider(),
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
            customdivider(),
            SwitchListTile(
              dense: true,
              title: customText(
                txt: 'Dark Mode',
                fsize: 18.0,
                fweight: FontWeight.w500,
              ),
              secondary: const Icon(
                Icons.dark_mode,
                color: Colors.white,
              ),
              value: darkmode,
              onChanged: (val) {
                setState(() {
                  darkmode = val;
                });
              },
            ),
            customdivider(),
            ListTile(
              dense: true,
              onTap: () {},
              title: customText(
                txt: 'Sign out',
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
                    txt: 'Share Clip', fsize: 22.0, fweight: FontWeight.w500),
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
    );
  }
}
