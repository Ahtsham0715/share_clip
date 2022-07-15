import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';
import 'package:share_clip/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: customPrimaryColor,
      drawer: Drawer(
        backgroundColor: customPrimaryColor,
      ),
      body: DefaultTabController(
        length: 2,
        child: CustomScrollView(slivers: [
          SliverAppBar(
            title: customText(txt: 'Share Clip'),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 35, 54, 65),
            // pinned: true,
            // floating: true,
            // snap: true,
            expandedHeight: responsiveHW(context, ht: 12),
            collapsedHeight: responsiveHW(context, ht: 11),
            flexibleSpace: const FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
            ),
            bottom: const TabBar(
              tabs: [
                Tab(text: "History", icon: Icon(Icons.history)),
                Tab(
                  text: "Pinned",
                  icon: Icon(Icons.push_pin_outlined),
                ),
              ],
            ),
          ),
          // SliverStickyHeader(
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              var docsnapshot = '';
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 19, right: 19, top: 13),
                  child: Column(
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                        ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          tileColor: const Color.fromARGB(255, 20, 35, 43),
                          title: Text(
                            docsnapshot.toString(),
                            style: const TextStyle(
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
            childCount: 5,
          )),
          // ),
        ]),
      ),
    );
  }
}
