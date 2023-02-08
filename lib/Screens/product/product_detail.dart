// ignore_for_file: use_key_in_widget_constructors, no_logic_in_create_state

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../../network/api.dart';

// ignore: must_be_immutable
class ProductDetails extends StatefulWidget {
  String idproduct;
  ProductDetails({required this.idproduct});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailsState createState() => _ProductDetailsState(idproduct);
}

class _ProductDetailsState extends State<ProductDetails> {
  String idproduct;
  _ProductDetailsState(this.idproduct);

  String nomortugas = '';
  String nomorstaff = '';
  List listdata = [];
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _getproductdetail();
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
          'Detail Product',
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
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      item['name'].toString(),
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 12),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Flexible(
                            //         child: Text(
                            //           item['cek_komisi'].toString(),
                            //           style: kTextStyle.copyWith(
                            //               color: kMainColorlama, fontSize: 10),
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 12),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Flexible(
                            //         child: Text(
                            //           item['cek_ppn'].toString(),
                            //           style: kTextStyle.copyWith(
                            //               color: kMainColorlama, fontSize: 10),
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 12),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Flexible(
                            //         child: Text(
                            //           item['textsewa'].toString(),
                            //           style: kTextStyle.copyWith(
                            //               color: kMainColorlama, fontSize: 10),
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Rp.${formatAmount(item['lst_price'].toString())}',
                                      style: kTextStyle.copyWith(
                                          color: kGreyTextColor),
                                    ),
                                  )
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
                                'deskripsi',
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
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      item['description'].toString(),
                                      style: kTextStyle.copyWith(
                                          color: kGreyTextColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: kBorderColorTextField,
                              thickness: 1.0,
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

  Future<void> _getproductdetail() async {
    EasyLoading.show(status: 'loading...');
    var data = {"id": idproduct};
    var res = await Network().auth(data, '/product_ruang');
    var body = json.decode(res.body);

    setState(() {
      listdata = body['result'];
    });
    EasyLoading.dismiss();
  }
}
