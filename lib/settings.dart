import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';
import 'package:share_clip/datafunctions.dart';
import 'package:share_clip/notifications.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // bool autosync = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: customText(
          txt: 'Settings',
          fsize: 22.0,
          fweight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            SwitchListTile(
              title: customText(
                txt: 'Auto Sync',
                fsize: 18.0,
                fweight: FontWeight.w500,
              ),
              secondary: const Icon(
                Icons.sync,
                color: Colors.white,
              ),
              value: box.read('autosync'),
              onChanged: (val) {
                setState(() {
                  // autosync = val;
                  box.write('autosync', val);
                });
              },
            ),
            customdivider(thick: 1.0),
            SwitchListTile(
              title: customText(
                txt: 'Notification',
                fsize: 18.0,
                fweight: FontWeight.w500,
              ),
              secondary: const Icon(
                Icons.notifications_active,
                color: Colors.white,
              ),
              value: box.read('notification'),
              onChanged: (val) {
                setState(() {
                  // autosync = val;
                  if(val){
                    shownotification();
                  }else{
                    AwesomeNotifications().cancelAll();
                  }
                  box.write('notification', val);
                });
              },
            ),
            customdivider(thick: 1.0),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(children: [
                  TextSpan(
                    text:
                        "ShareClip creates a link between all of your connected devices to increase productivity. Safely send text, photos, and data over the cloud. It's as easy as copy on one device and paste on another, working completely in the background.\n\nStop having to email yourself and increase your digital efficiency across multiple devices with Clipt.",
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            customdivider(thick: 1.0),
            ListTile(
              onTap: () {},
              title: customText(
                txt: 'Contact us',
                fsize: 18.0,
                fweight: FontWeight.w500,
              ),
              leading: const Icon(
                Icons.contact_page,
                color: Colors.white,
              ),
            ),
            customdivider(thick: 1.0),
            ListTile(
              onTap: () {},
              title: customText(
                txt: 'Delete Account',
                fsize: 18.0,
                fweight: FontWeight.w500,
              ),
              leading: const Icon(
                Icons.delete_forever,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
