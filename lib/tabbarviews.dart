
import 'package:flutter/material.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';
import 'package:share_clip/notifications.dart';

Widget tab1view(
  {
    required context,
    required trailingtxt,
    required titletxt,
    }
    ) {
  return  Column(
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.02,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
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
              shownotification();
            },
            color: Colors.teal,
            child: customText(txt: 'Send', clr: Colors.white),
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                  left: 19, right: 19, top: 13),
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
                        titletxt.toString(),
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: customText(
                          txt: trailingtxt.toString(),
                          txtalign: TextAlign.center,
                          clr: Colors.white),
                    ),
                    ListTile(
                      minVerticalPadding: 0.0,
                      leading: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5.0),
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
      return  const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
    }
Widget tab3view({
    required context,
    }) {
      return  const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
    }