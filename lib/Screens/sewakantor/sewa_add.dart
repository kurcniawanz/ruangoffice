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
class SewaAdd extends StatefulWidget {
  const SewaAdd({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SewaAddState createState() => _SewaAddState();
}

class _SewaAddState extends State<SewaAdd> {
  String actualDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  final dateController = TextEditingController();

  List listcustomer = [];
  List listagen = [];
  List listsales = [];
  List listproduct = [];

  String idcustomer = '0';
  String idsales = '0';
  String idagent = '0';
  String idproduct = '0';

  final deskripsiControler = TextEditingController();
  String deskripsi = '';
  final bulanControler = TextEditingController();
  String bulan = '';

  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _getlistcustomer();
    _getlistproduct();
  }

  @override
  void dispose() {
    dateController.dispose();
    deskripsiControler.dispose();
    bulanControler.dispose();
    super.dispose();
  }

  DropdownButton<String> getCustomer() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    const item = DropdownMenuItem(
      value: '0',
      child: Text(''),
    );
    dropDownItems.add(item);
    for (var emp in listcustomer) {
      var item = DropdownMenuItem(
        value: emp['id'].toString(),
        child: Text(
          emp['name'].toString(),
          style: const TextStyle(fontSize: 12),
        ),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: idcustomer,
      onChanged: (value) {
        setState(() {
          idcustomer = value!;
        });
      },
    );
  }

  DropdownButton<String> getSales() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    const item = DropdownMenuItem(
      value: '0',
      child: Text(''),
    );
    dropDownItems.add(item);
    for (var emp in listsales) {
      var item = DropdownMenuItem(
        value: emp['id'].toString(),
        child: Text(
          emp['name'].toString(),
          style: const TextStyle(fontSize: 12),
        ),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: idsales,
      onChanged: (value) {
        setState(() {
          idsales = value!;
        });
      },
    );
  }

  DropdownButton<String> getAgent() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    const item = DropdownMenuItem(
      value: '0',
      child: Text(''),
    );
    dropDownItems.add(item);
    for (var emp in listagen) {
      var item = DropdownMenuItem(
        value: emp['id'].toString(),
        child: Text(
          emp['name'].toString(),
          style: const TextStyle(fontSize: 12),
        ),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: idagent,
      onChanged: (value) {
        setState(() {
          idagent = value!;
        });
      },
    );
  }

  DropdownButton<String> getProduct() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    const item = DropdownMenuItem(
      value: '0',
      child: Text(''),
    );
    dropDownItems.add(item);
    for (var emp in listproduct) {
      var item = DropdownMenuItem(
        value: emp['id'].toString(),
        child: Text(
          emp['namecut'].toString(),
          style: const TextStyle(fontSize: 12),
        ),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: idproduct,
      onChanged: (value) {
        setState(() {
          idproduct = value!;
        });
      },
    );
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
          'Add Sewa Kantor',
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
                  SizedBox(
                    height: 60.0,
                    child: FormField(
                      builder: (FormFieldState<dynamic> field) {
                        return InputDecorator(
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Pilih Customer',
                              labelStyle: kTextStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          child:
                              DropdownButtonHideUnderline(child: getCustomer()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 60.0,
                    child: FormField(
                      builder: (FormFieldState<dynamic> field) {
                        return InputDecorator(
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Pilih Sales',
                              labelStyle: kTextStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          child: DropdownButtonHideUnderline(child: getSales()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 60.0,
                    child: FormField(
                      builder: (FormFieldState<dynamic> field) {
                        return InputDecorator(
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Pilih Agent',
                              labelStyle: kTextStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          child: DropdownButtonHideUnderline(child: getAgent()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 60.0,
                    child: FormField(
                      builder: (FormFieldState<dynamic> field) {
                        return InputDecorator(
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Pilih Product',
                              labelStyle: kTextStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          child:
                              DropdownButtonHideUnderline(child: getProduct()),
                        );
                      },
                    ),
                  ),
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
                              dateController.text =
                                  date.toString().substring(0, 10);
                            } else {
                              dateController.text = actualDate;
                            }
                          },
                          controller: dateController,
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
                    controller: bulanControler,
                    textFieldType: TextFieldType.NUMBER,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Lama sewa (Bulan)',
                      hintText: 'Lama sewa',
                    ),
                    onChanged: (value) {
                      bulan = value;
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
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
              child: Center(child: Text('Yakin add Paket RO ?')),
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
        'sewa_id': idcustomer,
        'file_name_1': idcustomer,
        'upload_file_1': idcustomer,
        'note_1': deskripsi,
        'user_1': namaa
      };

      var cekok = 1;

      if (cekok == 1) {
        var res = await Network().auth(data, '/add_paket');
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
      setState(() {
        isChecked = false;
      });
    }
  }

  Future<void> _getlistcustomer() async {
    EasyLoading.show(status: 'loading...');
    var data = {'id': '0'};
    var res = await Network().auth(data, '/getlistcustomer');
    var body = json.decode(res.body);

    setState(() {
      listcustomer = body['datacustomer'];
      listsales = body['datasales'];
      listagen = body['dataagent'];
    });

    EasyLoading.dismiss();
  }

  Future<void> _getlistproduct() async {
    EasyLoading.show(status: 'loading...');
    var data = {"id": "%"};
    var res = await Network().auth(data, '/product_ruang');
    var body = json.decode(res.body);

    setState(() {
      listproduct = body['result'];
    });

    EasyLoading.dismiss();
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
      desc: "add Sewa Kantor Success",
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
