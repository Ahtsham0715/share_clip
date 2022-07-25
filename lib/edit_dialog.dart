import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_clip/custom%20widgets/custom_widgets.dart';
import 'package:share_clip/datafunctions.dart';

final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
final TextEditingController devicecontroller = TextEditingController();

Widget customdailog(title, textfeild1, onpressed, button, {required context}) {
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

Widget customtextformfield(icon,
    {initialvalue,
    hinttext,
    controller,
    validator,
    onsaved,
    required context}) {
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

Future custombottomsheet({required context, required deviceslist}) async {
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
                itemCount: deviceslist.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: customText(
                          txt: deviceslist[index]['device_name'].toString(),
                          fsize: 20.0,
                          fweight: FontWeight.w400),
                      trailing: IconButton(
                        onPressed: () {
                          devicecontroller.text =
                              deviceslist[index]['device_name'].toString();
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
                                      context: context,
                                    ), () {
                                  if (_formkey.currentState!.validate()) {
                                    Get.back();
                                    Get.back();
                                    customdialogcircularprogressindicator(
                                        'Saving... ');
                                    editDeviceName(
                                            updatedName:
                                                devicecontroller.text.trim(),
                                            deviceid: deviceslist[index]
                                                    ['device_id']
                                                .toString())
                                        .then((value) {
                                      Get.back();
                                      // statesetter;
                                    });
                                  }
                                }, 'SUBMIT', context: context);
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
