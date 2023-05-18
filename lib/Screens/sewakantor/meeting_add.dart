// ignore_for_file: use_key_in_widget_constructors, no_logic_in_create_state

import 'dart:convert';

import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../GlobalComponents/button_global.dart';
import '../../constant.dart';
import '../../network/api.dart';

// ignore: must_be_immutable
class MeetingAdd extends StatefulWidget {
  String idsewa;
  MeetingAdd({required this.idsewa});

  @override
  // ignore: library_private_types_in_public_api
  _MeetingAddState createState() => _MeetingAddState(idsewa);
}

class _MeetingAddState extends State<MeetingAdd> {
  String idsewa;
  _MeetingAddState(this.idsewa);

  String actualDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  final datepicker1 = TextEditingController();
  final clockpicker1 = TextEditingController();
  final lama = TextEditingController();

  String jamnya = '';
  String lamanya = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    datepicker1.dispose();
    clockpicker1.dispose();
    lama.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Add Meeting',
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Container(
              width: context.width(),
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: kBgColor,
              ),
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          readOnly: true,
                          onTap: () async {
                            var date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));

                            if (date != null) {
                              datepicker1.text =
                                  date.toString().substring(0, 10);
                            } else {
                              datepicker1.text = actualDate;
                            }
                          },
                          controller: datepicker1,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: Icon(
                                Icons.date_range_rounded,
                                color: kGreyTextColor,
                              ),
                              labelText: 'Periode Awal'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  AppTextField(
                    controller: clockpicker1,
                    textFieldType: TextFieldType.OTHER,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Start Meeting',
                      hintText: 'Start sewa',
                    ),
                    onChanged: (value) {
                      jamnya = value;
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  AppTextField(
                    controller: lama,
                    textFieldType: TextFieldType.NUMBER,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Lama Meeting (jam)',
                      hintText: 'Lama sewa',
                    ),
                    onChanged: (value) {
                      lamanya = value;
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ButtonGlobal(
                    buttontext: 'Submit',
                    buttonDecoration:
                        kButtonDecoration.copyWith(color: kMainColorlama),
                    onPressed: () {
                      showExitPopup();
                      // const HomeScreen().launch(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'RuangOffice.com',
              style: kTextStyle.copyWith(color: kTitleColor, fontSize: 14),
            ),
            content: const SizedBox(
              width: 150,
              height: 40,
              child: Center(child: Text('Yakin add Meeting ?')),
            ),
            actions: [
              SizedBox(
                width: 60,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAlertColor,
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: const Text('No'),
                ),
              ),
              SizedBox(
                width: 60,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreenColor,
                  ),
                  onPressed: () => _adddata(),
                  //return true when click on "Yes"
                  child: const Text('Yes'),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _adddata() async {
    Navigator.of(context).pop(false);
    EasyLoading.show(status: 'loading...');

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var namaa = localStorage.getString('name').toString().replaceAll('"', '');

    var data = {
      'idsewaa': idsewa,
      'lama': lama.text,
      'datepicker1': datepicker1.text,
      'clockpicker1': clockpicker1.text,
      'user_1': namaa
    };

    var cekok = 1;

    if (cekok == 1) {
      var res = await Network().auth(data, '/add_meeting');
      var body = json.decode(res.body);

      debugPrint(body['result'].toString());

      if (body['result'].toString() == 'true') {
        // ignore: use_build_context_synchronously
        alertsukses(context);
      } else {
        // ignore: use_build_context_synchronously
        alertgagal(context, body['result'].toString());
      }
    }

    EasyLoading.dismiss();
  }

  void alertgagal(BuildContext context, String ketnya) {
    EasyLoading.dismiss();
    String alertnya = ketnya;
    Alert(
      context: context,
      type: AlertType.warning,
      title: " ",
      desc: alertnya,
      buttons: [
        DialogButton(
          child: const Text(
            "ok",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ).show();
    return;
  }

  void alertsukses(BuildContext context) {
    EasyLoading.dismiss();
    Alert(
      context: context,
      type: AlertType.success,
      title: " ",
      desc: "add Meeting Success",
      buttons: [
        DialogButton(
          child: const Text(
            "ok",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false),
        )
      ],
    ).show();

    return;
  }
}
