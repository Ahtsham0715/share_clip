import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';
import 'package:share_clip/datafunctions.dart';
import 'package:share_clip/notifications.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  if (!val) {
                    @override
                    void dispose() {
                      timer?.cancel();
                      super.dispose();
                    }
                  } else {
                    autosync();
                  }
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
                  if (val) {
                    shownotification();
                  } else {
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
              onTap: () async {
                String? encodeQueryParameters(Map<String, String> params) {
                  return params.entries
                      .map((e) =>
                          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                      .join('&');
                }

                final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'ahtsham50743@gmail.com',
                    query: encodeQueryParameters(<String, String>{
                      'subject': '',
                      'body': '',
                    }));

                await launchUrl(emailLaunchUri);
              },
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
              onTap: () {
                customYesNoDialog(
                    ctx: context,
                    titletext: 'Are You Sure?',
                    contenttext: 'Do you want to delete this account?',
                    yesOnTap: () async {
                      Navigator.pop(context);
                      try {
                        customdialogcircularprogressindicator('Deleting... ');
                        await currentuser?.delete();
                        Navigator.pop(context);
                        styledsnackbar(
                            txt: 'User Deleted Successfully',
                            icon: Icons.delete_forever_rounded);
                      } on FirebaseAuthException catch (e) {
                        Navigator.pop(context);
                        styledsnackbar(
                            txt: 'Error occured!. Try again.',
                            icon: Icons.sms_failed_outlined);
                      }
                    });
              },
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
