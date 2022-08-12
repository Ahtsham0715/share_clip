import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';
import 'package:share_clip/datafunctions.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:share_clip/notifications.dart';
import 'package:webview_flutter/webview_flutter.dart';

WebViewController? _controller;

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
              SyncData(isautosync: false);
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
                  txt: 'No Clipboard Data',
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
                                txt: datalist[index]['date'].toString() +
                                    '\n' +
                                    datalist[index]['time'].toString(),
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
                                        datalist[index]['clipboard_data']
                                            .toString(),
                                        showsnackbar: true);
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
                                        contenttext:
                                            'Do you want to delete it?',
                                        yesOnTap: () {
                                          Get.back();
                                          deletedata(
                                              docid: datalist[index]
                                                  .id
                                                  .toString());
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

Widget tab2view({required context, required datalist}) {
  return datalist.length == 0
      ? Center(
          child: customText(
              txt: 'No File Available',
              fsize: 25.0,
              fweight: FontWeight.w500,
              clr: Colors.white),
        )
      : ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: datalist.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: const Color.fromARGB(255, 20, 35, 43),
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: datalist[index]['filename'].toString(),
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.18,
                      child: WebView(
                        debuggingEnabled: true,
                        initialUrl: datalist[index]['filelink']
                                        .toString()
                                        .indexOf('.pdf') !=
                                    -1 ||
                                datalist[index]['filelink']
                                        .toString()
                                        .indexOf('.doc') !=
                                    -1 ||
                                datalist[index]['filelink']
                                        .toString()
                                        .indexOf('.docx') !=
                                    -1
                            ? 'https://docs.google.com/gview?embedded=true&url=${datalist[index]['filelink']}'
                            : datalist[index]['filelink'],
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated:
                            (WebViewController webViewController) {
                          _controller = webViewController;
                        },
                        //    gestureRecognizers: Set()
                        //             ..add(
                        //                 Factory<TapGestureRecognizer>(() => TapGestureRecognizer()
                        // ..onTapDown = (tap) {
                        //   styledsnackbar(txt: 'tapped inside');
                        //   launchUrl(datalist[index]['filelink']);
                        // })),
                        allowsInlineMediaPlayback: true,
                        zoomEnabled: true,
                      ),
                    ),
                    ListTile(
                      visualDensity: VisualDensity.comfortable,
                      // dense: true,
                      leading: const Icon(
                        FontAwesomeIcons.mobileScreen,
                        color: Colors.white,
                      ),
                      trailing: ButtonBar(
                        alignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // IconButton(
                          //   // splashColor: Colors.white,
                          //   onPressed: () {
                          //     // setclipboard(
                          //     //     datalist[index]['filelink'].toString());
                          //   },
                          //   icon: const Icon(
                          //     Icons.share,
                          //     color: Colors.white,
                          //   ),
                          //   tooltip: 'Share File',
                          // ),
                          IconButton(
                            // splashColor: Colors.white,
                            onPressed: () {
                              setclipboard(
                                  datalist[index]['filelink'].toString(),
                                  showsnackbar: true);
                            },
                            icon: const Icon(
                              Icons.link,
                              color: Colors.white,
                            ),
                            tooltip: 'copy link',
                          ),
                          IconButton(
                            onPressed: () {
                              downloadfile(
                                  ctx: context,
                                  fileurl: datalist[index]['filelink'],
                                  filename: datalist[index]['filename']);
                            },
                            icon: const Icon(
                              Icons.download_outlined,
                              color: Colors.white,
                            ),
                            tooltip: 'download file',
                          ),
                          IconButton(
                            onPressed: () {
                              customYesNoDialog(
                                  ctx: context,
                                  titletext: 'Are You Sure?',
                                  contenttext: 'Do you want to delete it?',
                                  yesOnTap: () {
                                    Get.back();
                                    deletefile(
                                      docid: datalist[index].id.toString(),
                                      url: datalist[index]['filelink']
                                          .toString(),
                                    );
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
                // ListTile(
                //   minVerticalPadding: 0.0,
                //   // leading: const Padding(
                //   //   padding: EdgeInsets.symmetric(vertical: 5.0),
                //   //   child: Icon(
                //   //     FontAwesomeIcons.mobileScreen,
                //   //     color: Colors.white,
                //   //   ),
                //   // ),
                //   title: WebView(
                //     initialUrl: datalist[index]['filelink'],
                //     javascriptMode: JavascriptMode.unrestricted,
                //   ),
                // trailing: customText(
                //               txt: datalist[index]['date'].toString(),
                //               txtalign: TextAlign.center,
                //               clr: Colors.white),
                // ),
              ),
            );
          },
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
                                  datalist[index]['clipboard_data'].toString(),
                                  showsnackbar: true);
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
                                  yesOnTap: () {
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
