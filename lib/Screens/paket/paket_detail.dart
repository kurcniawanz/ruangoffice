// ignore_for_file: use_key_in_widget_constructors, no_logic_in_create_state

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../GlobalComponents/button_global.dart';
import '../../constant.dart';
import '../../network/api.dart';
import 'paket_serah.dart';

// ignore: must_be_immutable
class PaketDetails extends StatefulWidget {
  String idpaket;
  PaketDetails({required this.idpaket});

  @override
  // ignore: library_private_types_in_public_api
  _PaketDetailsState createState() => _PaketDetailsState(idpaket);
}

class _PaketDetailsState extends State<PaketDetails> {
  String idpaket;
  _PaketDetailsState(this.idpaket);

  String nomortugas = '';
  String nomorstaff = '';
  List listdata = [];
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _getpaketdetail();
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
          'Detail Paket',
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
                // crossAxisAlignment: CrossAxisAlignment.center,
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
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      item['sewa_id'].toString(),
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontSize: 16,
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
                                          color: kTitleColor, fontSize: 14),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
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
                            ),
                            Row(children: [
                              Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: const Divider(
                                      color: kGreyTextColor,
                                      height: 36,
                                    )),
                              ),
                              Text(
                                'Peneriaan Paket',
                                style: kTextStyle.copyWith(
                                    color: kGreyTextColor, fontSize: 12),
                              ),
                              Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: const Divider(
                                      color: kGreyTextColor,
                                      height: 36,
                                    )),
                              ),
                            ]),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      item['note_1'].toString(),
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor, fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.memory(
                                      convertBase64Image(item['upload_file_1']),
                                      gaplessPlayback: true,
                                      width: 200,
                                      height: 300,
                                      fit: BoxFit.fill)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Diterima Oleh ${item['user_1']} pada ${item['create_date']}',
                                    style: kTextStyle.copyWith(
                                        color: kMainColorlama, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            if (item['upload_file_2'].toString() != '') ...[
                              Row(children: [
                                Expanded(
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: const Divider(
                                        color: kGreyTextColor,
                                        height: 36,
                                      )),
                                ),
                                Text(
                                  'Penyerahan Paket',
                                  style: kTextStyle.copyWith(
                                      color: kGreyTextColor, fontSize: 12),
                                ),
                                Expanded(
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: const Divider(
                                        color: kGreyTextColor,
                                        height: 36,
                                      )),
                                ),
                              ]),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        item['note_2'].toString(),
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor, fontSize: 12),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.memory(
                                        convertBase64Image(
                                            item['upload_file_2']),
                                        gaplessPlayback: true,
                                        width: 200,
                                        height: 300,
                                        fit: BoxFit.fill)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Diserahkan Oleh ${item['user_2']} pada ${item['write_date']}',
                                      style: kTextStyle.copyWith(
                                          color: kMainColorlama, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                            ] else ...[
                              ButtonGlobal(
                                buttontext: 'Penyerahan Paket',
                                buttonDecoration: kButtonDecoration.copyWith(
                                    color: kGreenColor),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PaketSerah(
                                          idsewa: item['id'].toString(),
                                          nohp: item['no_hp'].toString())));
                                  // const HomeScreen().launch(context);
                                },
                              ),
                            ]
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

  Future<void> _getpaketdetail() async {
    EasyLoading.show(status: 'loading...');
    var data = {"id": idpaket};
    var res = await Network().auth(data, '/paket_ruang_detail');
    var body = json.decode(res.body);

    debugPrint(body.toString());

    setState(() {
      listdata = body['result'];
    });
    EasyLoading.dismiss();
  }

  Uint8List convertBase64Image(String base64String) {
    return const Base64Decoder().convert(base64String);
  }
}
