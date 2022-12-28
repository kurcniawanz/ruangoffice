import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../../network/api.dart';
import 'paket_add.dart';
import 'paket_detail.dart';

class PaketList extends StatefulWidget {
  const PaketList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PaketListState createState() => _PaketListState();
}

class _PaketListState extends State<PaketList> {
  List listdata = [];
  String ketdata = '';

  @override
  void initState() {
    super.initState();
    _getpaketdata('draft');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => const PaketAdd().launch(context),
        backgroundColor: kMainColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: AppBar(
          backgroundColor: kMainColor,
          elevation: 0.0,
          titleSpacing: 0.0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'List Paket RO',
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
                _getpaketdata('%');
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
                    ' Draft ',
                    style: kTextStyle.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                ),
              ).onTap(() {
                _getpaketdata('draft');
              }),
            ),
          ]),
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
                                builder: (context) => PaketDetails(
                                    idpaket: item['id'].toString())));
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
                                      '',
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      item['cabang_id'].toString(),
                                      style: kTextStyle.copyWith(
                                          color: kMainColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      item['name'].toString(),
                                      style: kTextStyle.copyWith(
                                          color: kGreyTextColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '',
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
                                      item['sewa_id'].toString(),
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '',
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
                                      item['company_name'].toString(),
                                      style: kTextStyle.copyWith(
                                        color: kGreyTextColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Spacer(),
                                    if (item['state'] == '2') ...[
                                      Text(
                                        'Done',
                                        style: kTextStyle.copyWith(
                                            color: kGreenColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ] else ...[
                                      Text(
                                        'Draft',
                                        style: kTextStyle.copyWith(
                                            color: kAlertColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]
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

  Future<void> _getpaketdata(String kodenya) async {
    EasyLoading.show(status: 'loading...');
    setState(() {
      ketdata = 'sedang mengambil data...';
    });

    var data = {"id": kodenya};
    var res = await Network().auth(data, '/paket_ruang');
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
    var res = await Network().auth(data, '/paket_ruang_2');
    var body = json.decode(res.body);
    setState(() {
      listdata = body['result'];
    });
  }
}
