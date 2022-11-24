// ignore_for_file: use_key_in_widget_constructors, no_logic_in_create_state

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../GlobalComponents/button_global.dart';
import '../../constant.dart';
import '../../network/api.dart';

// ignore: must_be_immutable
class PaketSerah extends StatefulWidget {
  String idsewa;
  String nohp;
  PaketSerah({required this.idsewa, required this.nohp});

  @override
  // ignore: library_private_types_in_public_api
  _PaketSerahState createState() => _PaketSerahState(idsewa, nohp);
}

class _PaketSerahState extends State<PaketSerah> {
  String idsewa;
  String nohp;
  _PaketSerahState(this.idsewa, this.nohp);

  String nomortugas = '';
  String nomorstaff = '';
  List listdata = [];
  bool isChecked = false;

  String filename = '';
  String base64file = '';
  String imageok = '';
  late File imageFile;
  final descControler = TextEditingController();
  String deskripsi = '';

  @override
  void initState() {
    super.initState();
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
          'Penyerahan Paket RO',
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
                  AppTextField(
                    controller: descControler,
                    textFieldType: TextFieldType.NAME,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Deskripsi penerimaan paket',
                      hintText: 'Description',
                    ),
                    onChanged: (value) {
                      deskripsi = value;
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  if (filename != '')
                    Text(
                      filename,
                      textAlign: TextAlign.center,
                      style: kTextStyle.copyWith(
                          color: kGreyTextColor, fontSize: 10),
                    ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                      onPressed: () => getImage(source: ImageSource.camera),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: kMainColor),
                      child: const Text(
                        'Take Picture',
                        style: TextStyle(fontSize: 14),
                      )),
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

  Uint8List convertBase64Image(String base64String) {
    return const Base64Decoder().convert(base64String);
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
              child: Center(child: Text('Yakin Penyerahan Paket RO ?')),
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
    if (isChecked == false) {
      EasyLoading.show(status: 'loading...');
      setState(() {
        isChecked = true;
      });

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var namaa = localStorage.getString('name').toString().replaceAll('"', '');

      var data = {
        'sewa_id': idsewa,
        'file_name_2': filename,
        'upload_file_2': base64file,
        'note_2': deskripsi,
        'user_2': namaa,
        'no_hp': nohp
      };

      var cekok = 1;

      if (base64file == '') {
        cekok = 0;
        // ignore: use_build_context_synchronously
        alertgagal(context, 'Take Picture Terlebih dahulu.');
      }

      if (cekok == 1) {
        var res = await Network().auth(data, '/serah_paket');
        var body = json.decode(res.body);

        if (body['result'].toString() == 'true') {
          // ignore: use_build_context_synchronously
          alertsukses(context);
        } else {
          // ignore: use_build_context_synchronously
          alertgagal(context, body['result'].toString());
        }
      }

      EasyLoading.dismiss();
      setState(() {
        isChecked = false;
      });
    }
  }

  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(source: source);
    if (file?.path != null) {
      var fullpath = File(file!.path);
      var namenya = (fullpath.toString()).split('/');
      Uint8List imgbytes = await fullpath.readAsBytes();
      var result64 = await FlutterImageCompress.compressWithList(
        imgbytes,
        quality: 96,
      );
      String bs4str = base64.encode(result64);
      setState(() {
        imageFile = fullpath;
        filename = namenya[namenya.length - 1].toString();
        base64file = bs4str;
      });
    }
  }

  void alertgagal(BuildContext context, String ketnya) {
    EasyLoading.dismiss();
    setState(() {
      isChecked = false;
    });
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
    setState(() {
      isChecked = false;
    });
    Alert(
      context: context,
      type: AlertType.success,
      title: " ",
      desc: "Penyerahan Paket Success",
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
