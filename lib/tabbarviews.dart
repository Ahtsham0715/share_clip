import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';
import 'package:share_clip/datafunctions.dart';
import 'package:share_clip/notifications.dart';

Widget tab1view({required context, required datalist}) {
  // print(datalist[0]['clipboard_data']);
  return Column(
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.02,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
                borderRadius: BorderRadius.circular(5.0)),
            onPressed: () {
              // shownotification();
              SyncData();
            },
            color: Colors.teal,
            child: customText(txt: 'Sync', clr: Colors.white),
          ),
        ),
      ),
      datalist.length == 0
          ? Expanded(
              child: Center(
                child: customText(
                  txt: 'No Unpinned Data',
                  fsize: 22.0,
                  fweight: FontWeight.w500,
                  clr: Colors.white,
                  // padding: 20.0
                ),
              ),
            )
          : Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: datalist.length,
                itemBuilder: (context, index) {
                  return Padding(
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
                            title: Text(
                              datalist[index]['clipboard_data'].toString(),
                              style: TextStyle(
                                fontSize: 17.0,
                                color: Colors.white,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: customText(
                                txt: datalist[index]['date'].toString(),
                                txtalign: TextAlign.center,
                                clr: Colors.white),
                          ),
                          ListTile(
                            minVerticalPadding: 0.0,
                            leading: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Icon(
                                FontAwesomeIcons.mobileScreen,
                                color: Colors.white,
                              ),
                            ),
                            title: ButtonBar(
                              alignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  // splashColor: Colors.white,
                                  onPressed: () {
                                    setclipboard(datalist[index]
                                            ['clipboard_data']
                                        .toString());
                                  },
                                  icon: const Icon(
                                    Icons.copy_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    pintoggle(
                                        docid: datalist[index].id.toString(),
                                        ispinned: true);
                                  },
                                  icon: const Icon(
                                    Icons.push_pin_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                     customYesNoDialog(
                                  ctx: context,
                                  titletext: 'Are You Sure?',
                                  contenttext: 'Do you want to delete it?',
                                  yesOnTap: (){
                                    Get.back();
                                    deletedata(
                                      docid: datalist[index].id.toString());
                                  });
                                  },
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
                  );
                },
              ),
            ),
    ],
  );
}

Widget tab2view({
  required context,
}) {
  return const Center(
    child: CircularProgressIndicator(
      color: Colors.white,
    ),
  );
}

Widget tab3view({required context, required datalist}) {
  return datalist.length == 0
      ? Center(
          child: customText(
              txt: 'No Pinned Data',
              fsize: 22.0,
              fweight: FontWeight.w500,
              clr: Colors.white),
        )
      : ListView.builder(
          shrinkWrap: true,
          itemCount: datalist.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 19, right: 19, top: 13),
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
                      title: Text(
                        datalist[index]['clipboard_data'].toString(),
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: customText(
                          txt: datalist[index]['date'].toString(),
                          txtalign: TextAlign.center,
                          clr: Colors.white),
                    ),
                    ListTile(
                      minVerticalPadding: 0.0,
                      leading: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Icon(
                          FontAwesomeIcons.mobileScreen,
                          color: Colors.white,
                        ),
                      ),
                      title: ButtonBar(
                        alignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            // splashColor: Colors.white,
                            onPressed: () {
                              setclipboard(
                                  datalist[index]['clipboard_data'].toString());
                            },
                            icon: const Icon(
                              Icons.copy_outlined,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              pintoggle(
                                  docid: datalist[index].id.toString(),
                                  ispinned: false);
                            },
                            icon: const Icon(
                              CupertinoIcons.pin_slash,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                             customYesNoDialog(
                                  ctx: context,
                                  titletext: 'Are You Sure?',
                                  contenttext: 'Do you want to delete it?',
                                  yesOnTap: (){
                                    Get.back();
                                    deletedata(
                                      docid: datalist[index].id.toString());
                                  });
                            },
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
            );
          },
        );
}
