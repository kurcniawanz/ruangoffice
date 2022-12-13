// ignore_for_file: use_key_in_widget_constructors, no_logic_in_create_state

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../GlobalComponents/button_global.dart';
import '../../constant.dart';
import '../../network/api.dart';

// ignore: must_be_immutable
class ProductAdd extends StatefulWidget {
  const ProductAdd({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProductAddState createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  bool isChecked = false;

  final deskripsiControler = TextEditingController();
  String deskripsi = '';
  final nameproductControler = TextEditingController();
  String nameproduct = '';
  final hargaControler = TextEditingController();
  String harga = '';

  bool cekppn = false;
  bool cekkomisi = false;
  bool ceksewa = false;

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
          'Add Product',
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
                    controller: nameproductControler,
                    textFieldType: TextFieldType.NAME,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Product Name',
                      hintText: 'Name',
                    ),
                    onChanged: (value) {
                      nameproduct = value;
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  AppTextField(
                    controller: hargaControler,
                    textFieldType: TextFieldType.NUMBER,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Product Price',
                      hintText: 'Price',
                    ),
                    onChanged: (value) {
                      harga = value;
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: cekppn,
                          activeColor: kMainColor,
                          thumbColor: kGreyTextColor,
                          onChanged: (bool value) {
                            setState(() {
                              cekppn = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        'Product PPN',
                        style: kTextStyle,
                      ),
                      const Spacer(),
                      Text(
                        ' ',
                        style: kTextStyle,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: ceksewa,
                          activeColor: kMainColor,
                          thumbColor: kGreyTextColor,
                          onChanged: (bool value) {
                            setState(() {
                              ceksewa = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        'Product Sewa',
                        style: kTextStyle,
                      ),
                      const Spacer(),
                      Text(
                        ' ',
                        style: kTextStyle,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: cekkomisi,
                          activeColor: kMainColor,
                          thumbColor: kGreyTextColor,
                          onChanged: (bool value) {
                            setState(() {
                              cekkomisi = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        'Dapat Komisi',
                        style: kTextStyle,
                      ),
                      const Spacer(),
                      Text(
                        ' ',
                        style: kTextStyle,
                      ),
                    ],
                  ),
                  AppTextField(
                    controller: deskripsiControler,
                    textFieldType: TextFieldType.MULTILINE,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Deskripsi Product',
                      hintText: 'Description',
                    ),
                    onChanged: (value) {
                      deskripsi = value;
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
              child: Center(child: Text('Yakin add Product RO ?')),
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

      var data = {
        'product_name': nameproduct,
        'product_price': harga,
        'deskripsi': deskripsi,
        'cek_ppn': cekppn,
        'cek_komisi': cekkomisi,
        "cek_sewa": ceksewa
      };

      var cekok = 1;

      if (cekok == 1) {
        var res = await Network().auth(data, '/add_product');

        debugPrint(res.body.toString());

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
      desc: "add Product Success",
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
