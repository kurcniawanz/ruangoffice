import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../../network/api.dart';
import 'invoice_detail.dart';

class KerjaList extends StatefulWidget {
  const KerjaList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _KerjaListState createState() => _KerjaListState();
}

class _KerjaListState extends State<KerjaList> {
  List listdata = [];
  String ketdata = '';

  @override
  void initState() {
    super.initState();
    _getinvoicedata();
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
          'List Invoice',
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
                        hintText: 'e.g INV001',
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
                                builder: (context) => KerjaDetails(
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
                                      '#${item['name']}',
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      item['sales_user'][1].toString(),
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
                                          fontSize: 16,
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
                                      'Rp.${formatAmount(item['totakhir'].toString())}',
                                      style: kTextStyle.copyWith(
                                          color: kGreyTextColor,
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

  Future<void> _getinvoicedata() async {
    EasyLoading.show(status: 'loading...');
    setState(() {
      ketdata = 'sedang mengambil data...';
    });

    var data = {"name": "%"};
    var res = await Network().auth(data, '/invoice_ruang');
    var body = json.decode(res.body);
    setState(() {
      listdata = body['result'];
    });

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
    var data = {"name": varsearch};
    var res = await Network().auth(data, '/invoice_ruang');
    var body = json.decode(res.body);
    setState(() {
      listdata = body['result'];
    });
  }
}
