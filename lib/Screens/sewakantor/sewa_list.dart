import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../../network/api.dart';
import 'sewa_detail.dart';

class SewaList extends StatefulWidget {
  const SewaList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SewaListState createState() => _SewaListState();
}

class _SewaListState extends State<SewaList> {
  List listdata = [];
  String ketdata = '';

  @override
  void initState() {
    super.initState();
    _getpaketdata();
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
          'List Sewa Kantor',
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
                        hintText: 'e.g nama customer',
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
                                builder: (context) => SewaDetails(
                                    idsewa: item['id'].toString())));
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
                                      item['partner_id'].toString(),
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      item['company_name'].toString(),
                                      style: kTextStyle.copyWith(
                                        color: kGreyTextColor,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      item['product_nama'].toString(),
                                      style: kTextStyle.copyWith(
                                          color: kGreyTextColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    if (item['state'] == '2') ...[
                                      Text(
                                        'Expired',
                                        style: kTextStyle.copyWith(
                                            color: kAlertColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ] else ...[
                                      Text(
                                        'Draft',
                                        style: kTextStyle.copyWith(
                                            color: kGreenColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Expired : ${item['periode_akhir']}",
                                      style: kTextStyle.copyWith(
                                        color: kMainColorlama,
                                        fontSize: 10,
                                      ),
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

  Future<void> _getpaketdata() async {
    EasyLoading.show(status: 'loading...');
    setState(() {
      ketdata = 'sedang mengambil data...';
    });

    var data = {"id": "0"};
    var res = await Network().auth(data, '/sewa_kator');
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
    var data = {"id": varsearch};
    var res = await Network().auth(data, '/sewa_kator');
    var body = json.decode(res.body);
    setState(() {
      listdata = body['result'];
    });
  }
}
