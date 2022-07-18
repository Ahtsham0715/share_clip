import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';
import 'package:share_clip/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: customPrimaryColor,
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              backgroundColor: Colors.deepPurple[400],
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: UserAccountsDrawerHeader(
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
            ),
            ListTile(
              onTap: () {},
              title: customText(txt: 'Settings', fsize: 19.0),
              leading: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 2,
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
                      onPressed: () {},
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
                  tabs: const [
                    Tab(text: "History", icon: Icon(Icons.history)),
                    Tab(
                      text: "Pinned",
                      icon: Icon(Icons.push_pin_outlined),
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
                      child: Column(
                        children: ListTile.divideTiles(
                          context: context,
                          tiles: [
                            ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              tileColor: const Color.fromARGB(255, 20, 35, 43),
                              title: const Text(
                                'd',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // trailing: Icon(
                              //   IconData(
                              //     args['department_icon_code'],
                              //     fontFamily: args['department_icon_fontfamily'],
                              //     fontPackage: args['department_icon_fontpackage'],
                              //   ),
                              //   color: Colors.teal,
                              //   size: 33,
                              // ),
                            ),
                          ],
                        ).toList(),
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
            ],
          ),
        ),
      ),
    );
  }
}
