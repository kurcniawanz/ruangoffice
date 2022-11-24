import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../../network/api.dart';
import 'product_detail.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List listdata = [];
  String ketdata = '';

  @override
  void initState() {
    super.initState();
    _getproductdata();
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
          'List Product',
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
                        hintText: 'e.g virtual office',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _searchproduct(value);
                        // email = value;
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
                                builder: (context) => ProductDetails(
                                    idproduct: item['id'].toString())));
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
                                    Flexible(
                                      child: Text(
                                        item['name'].toString(),
                                        maxLines: 2,
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    if (item['cek_komisi'] ==
                                        'Tanpa Komisi') ...[
                                      Text(
                                        item['cek_komisi'].toString(),
                                        style: kTextStyle.copyWith(
                                            color: kAlertColor, fontSize: 12),
                                      ),
                                    ] else ...[
                                      Text(
                                        item['cek_komisi'].toString(),
                                        style: kTextStyle.copyWith(
                                            color: kGreenColor, fontSize: 12),
                                      ),
                                    ]
                                  ],
                                ),
                                Row(
                                  children: [
                                    if (item['cek_ppn'] ==
                                        'Tanpa PPN(11%)') ...[
                                      Text(
                                        item['cek_ppn'],
                                        style: kTextStyle.copyWith(
                                            color: kAlertColor, fontSize: 12),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Rp.${formatAmount(item['lst_price'].toString())}',
                                        style: kTextStyle.copyWith(
                                            color: kGreyTextColor,
                                            fontSize: 12),
                                      ),
                                    ] else ...[
                                      Text(
                                        item['cek_ppn'],
                                        style: kTextStyle.copyWith(
                                            color: kGreenColor, fontSize: 12),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Rp.${formatAmount(item['lst_price'].toString())}',
                                        style: kTextStyle.copyWith(
                                            color: kGreyTextColor,
                                            fontSize: 12),
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

  Future<void> _getproductdata() async {
    EasyLoading.show(status: 'loading...');
    setState(() {
      ketdata = 'sedang mengambil data...';
    });

    var data = {"id": "%"};
    var res = await Network().auth(data, '/product_ruang');
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

  Future<void> _searchproduct(String valsearch) async {
    var data = {"name": valsearch};
    var res = await Network().auth(data, '/product_ruang_search');
    var body = json.decode(res.body);
    setState(() {
      listdata = body['result'];
    });
  }
}
