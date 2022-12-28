import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../../network/api.dart';
import 'proforma_detail.dart';

class ProformaList extends StatefulWidget {
  const ProformaList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProformaListState createState() => _ProformaListState();
}

class _ProformaListState extends State<ProformaList> {
  List listdata = [];
  String ketdata = '';

  String levelid = '';
  String cabangid = '';
  String userid = '';

  @override
  void initState() {
    super.initState();
    _getinvoicedata('2');
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
          'List Pro-Forma',
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 50.0,
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white.withOpacity(0.1),
              ),
              child: Center(
                child: Text(
                  ' All ',
                  style: kTextStyle.copyWith(
                      color: Colors.white, fontWeight: FontWeight.normal),
                ),
              ),
            ).onTap(() {
              _getinvoicedata('1');
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 50.0,
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white.withOpacity(0.1),
              ),
              child: Center(
                child: Text(
                  ' Mine ',
                  style: kTextStyle.copyWith(
                      color: Colors.white, fontWeight: FontWeight.normal),
                ),
              ),
            ).onTap(() {
              _getinvoicedata('2');
            }),
          ),
        ],
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
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 40.0,
                    child: AppTextField(
                      // controller: userController,
                      textFieldType: TextFieldType.NAME,
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        hintText: 'e.g PNV001',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _searchdata(value);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  if (listdata.isNotEmpty) ...[
                    for (var item in listdata)
                      Material(
                        elevation: 2.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProformaDetails(
                                    noinv: item['name'].toString())));
                          },
                          child: Container(
                            width: context.width(),
                            padding: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: kMainColor,
                                  width: 3.0,
                                ),
                              ),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      item['industry_id'][1].toString(),
                                      style: kTextStyle.copyWith(
                                          color: kMainColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '#${item['name']} / ${item['tglinput']}',
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${item['sales_user'][1]} ${item['agentnya']}",
                                      style: kTextStyle.copyWith(
                                          color: kMainColorlama,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      item['partner_id'][1].toString(),
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Kerjaan ${item['statuskerjaan']}',
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor, fontSize: 12),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      item['company_name'].toString(),
                                      style: kTextStyle.copyWith(
                                        color: kGreyTextColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Spacer(),
                                    if (item['stat'] == 'LUNAS') ...[
                                      Text(
                                        item['stat'].toString(),
                                        style: kTextStyle.copyWith(
                                            color: kGreenColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ] else ...[
                                      Text(
                                        item['stat'].toString(),
                                        style: kTextStyle.copyWith(
                                            color: kAlertColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '',
                                      style: kTextStyle.copyWith(
                                        color: kGreyTextColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Rp.${formatAmount(item['totakhir'].toString())}',
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: kBorderColorTextField,
                                  thickness: 1.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ] else ...[
                    Center(
                      child: Text(
                        ketdata,
                        style: kTextStyle.copyWith(
                          color: kGreyTextColor,
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getinvoicedata(String kodenya) async {
    EasyLoading.show(status: 'loading...');
    setState(() {
      ketdata = 'sedang mengambil data...';
    });

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
      "name": "%",
      "level_id": levelid,
      "kodenya": kodenya,
      "cabang": cabangid,
      "iduser": userid
    };
    var res = await Network().auth(data, '/proforma_ruang');
    var body = json.decode(res.body);
    setState(() {
      listdata = body['result'];
    });

    debugPrint(listdata.toString());

    if (listdata.isNotEmpty) {
      debugPrint('data ada');
    } else {
      setState(() {
        ketdata = 'data tidak tersedia.';
      });
    }
    EasyLoading.dismiss();
  }

  Future<void> _searchdata(String varsearch) async {
    var data = {
      "name": varsearch,
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
  }
}
