// ignore_for_file: use_key_in_widget_constructors, no_logic_in_create_state

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../../network/api.dart';
import 'meeting_list.dart';

// ignore: must_be_immutable
class SewaDetails extends StatefulWidget {
  String idsewa;
  SewaDetails({required this.idsewa});

  @override
  // ignore: library_private_types_in_public_api
  _SewaDetailsState createState() => _SewaDetailsState(idsewa);
}

class _SewaDetailsState extends State<SewaDetails> {
  String idsewa;
  _SewaDetailsState(this.idsewa);

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
                            const SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: Text(
                                      item['cabang_id'].toString(),
                                      style: kTextStyle.copyWith(
                                          color: kMainColor,
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
                                      item['partner_id'].toString(),
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
                                          color: kTitleColor, fontSize: 12),
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
                                      "${item['no_hp']}",
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
                                      "${item['street']} ${item['city']} ${item['zip_code']}",
                                      style: kTextStyle.copyWith(
                                          color: kGreyTextColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      item['product_nama'].toString(),
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Lama Sewa : ${item['lama']} Bulan",
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
                                      "Periode Awal : ${item['periode_awal']}",
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
                                      "Expired : ${item['periode_akhir']}",
                                      style: kTextStyle.copyWith(
                                          color: kGreyTextColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              child: Row(
                                children: [
                                  Text(
                                    'Free meeting ${item['sisa_meeting']} jam',
                                    style: kTextStyle.copyWith(
                                        color: kMainColorlama,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => MeetingList(
                                                  idsewa:
                                                      item['id'].toString())));
                                    },
                                    child: Text(
                                      'detail >',
                                      style: kTextStyle.copyWith(
                                          color: kGreyTextColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
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

  Future<void> _getpaketdetail() async {
    EasyLoading.show(status: 'loading...');
    var data = {"id": idsewa};
    var res = await Network().auth(data, '/sewa_kator_detail');
    var body = json.decode(res.body);

    setState(() {
      listdata = body['result'];
    });
    EasyLoading.dismiss();
  }

  Uint8List convertBase64Image(String base64String) {
    return const Base64Decoder().convert(base64String);
  }
}
