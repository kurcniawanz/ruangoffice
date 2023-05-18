// ignore_for_file: use_key_in_widget_constructors, no_logic_in_create_state

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../../network/api.dart';

// ignore: must_be_immutable
class ProformaDetails extends StatefulWidget {
  String noinv;
  ProformaDetails({required this.noinv});

  @override
  // ignore: library_private_types_in_public_api
  _ProformaDetailsState createState() => _ProformaDetailsState(noinv);
}

class _ProformaDetailsState extends State<ProformaDetails> {
  String noinv;
  _ProformaDetailsState(this.noinv);

  String nomortugas = '';
  String nomorstaff = '';
  List listdata = [];
  bool isChecked = false;

  String levelid = '';
  String cabangid = '';
  String userid = '';

  @override
  void initState() {
    super.initState();
    _getinvdetail();
  }

  @override
  Widget build(BuildContext context) {
    String formatAmount(price) {
      String priceInText = "";
      int counter = 0;
      for (int i = (price.length - 1); i >= 0; i--) {
        counter++;
        String str = price[i];
        if ((counter % 3) != 0 && i != 0) {
          priceInText = "$str$priceInText";
        } else if (i == 0) {
          priceInText = "$str$priceInText";
        } else {
          priceInText = ",$str$priceInText";
        }
      }
      return priceInText.trim();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Detail Pro-Forma',
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // actions: const [
        //   Image(
        //     image: AssetImage('images/employeesearch.png'),
        //   ),
        // ],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (var item in listdata)
                    Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: context.width(),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: Text(
                                      item['industry_id'][1].toString(),
                                      style: kTextStyle.copyWith(
                                          color: kMainColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: Text(
                                      item['statuskerjaan'].toString(),
                                      style: kTextStyle.copyWith(
                                          color: kAlertColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '#${item['name']}',
                                      style: kTextStyle.copyWith(
                                          color: kGreyTextColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      item['partner_id'][1].toString(),
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      item['company_name'].toString(),
                                      style: kTextStyle.copyWith(
                                          color: kGreyTextColor, fontSize: 10),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Divider(
                              color: kBorderColorTextField,
                              thickness: 1.0,
                            ),
                            for (var prod in item['listproduct'])
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '- $prod',
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor, fontSize: 10),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            const Divider(
                              color: kBorderColorTextField,
                              thickness: 1.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Total',
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      formatAmount(item['totakhir'].toString()),
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Divider(
                              color: kBorderColorTextField,
                              thickness: 1.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Marketing : ${item['sales_user'][1]}',
                                      style: kTextStyle.copyWith(
                                          color: kMainColorlama,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getinvdetail() async {
    EasyLoading.show(status: 'loading...');

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var levelnya =
        localStorage.getString('level_id').toString().replaceAll('"', '');
    var cabangnya =
        localStorage.getString('cabang').toString().replaceAll('"', '');
    var iduser =
        localStorage.getString('iduser').toString().replaceAll('"', '');

    setState(() {
      levelid = levelnya;
      cabangid = cabangnya;
      userid = iduser;
    });

    var data = {
      "name": noinv,
      "level_id": levelid,
      "kodenya": '1',
      "cabang": cabangid,
      "iduser": userid
    };

    var res = await Network().auth(data, '/proforma_ruang');
    var body = json.decode(res.body);

    setState(() {
      listdata = body['result'];
    });
    EasyLoading.dismiss();
  }
}
