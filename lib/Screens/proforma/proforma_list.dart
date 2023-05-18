import 'dart:convert';

import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';

import '../../constant.dart';
import '../../network/api.dart';
import 'proforma_detail.dart';

class ProformaList extends StatefulWidget {
  const ProformaList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProformaListState createState() => _ProformaListState();
}

class _ProformaListState extends State<ProformaList>
    with TickerProviderStateMixin {
  List listdata = [];
  List liscabang = [];
  String ketdata = '';

  String levelid = '';
  String cabangid = '';
  String userid = '';

  late TabController controllertab;

  List<Widget> listtab = [
    const Tab(
      text: "     All     ",
    ),
    const Tab(
      text: "  	TANGERANG 'Green Lake City'  ",
    ),
    const Tab(
      text: "  JAKARTA BARAT 'Green Garden'  ",
    ),
    const Tab(
      text: "  INDONESIA  ",
    )
  ];

  @override
  void initState() {
    super.initState();
    controllertab = TabController(length: listtab.length, vsync: this);
    controllertab.addListener(() {
      if (controllertab.index == 1) {
        _getinvoicedata('3');
        debugPrint("Selected Index: tangerang");
      } else if (controllertab.index == 2) {
        _getinvoicedata('4');
        debugPrint("Selected Index: jakartabarat");
      } else if (controllertab.index == 3) {
        _getinvoicedata('5');
        debugPrint("Selected Index: indonesi");
      } else {
        _getinvoicedata('1');
        debugPrint("Selected Index: all");
      }
    });

    _getinvoicedata('1');
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
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(listdata),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: listtab.length,
          child: Column(
            children: <Widget>[
              ButtonsTabBar(
                backgroundColor: Colors.white,
                unselectedBackgroundColor: kMainColor,
                unselectedLabelStyle: const TextStyle(color: Colors.white),
                labelStyle: const TextStyle(
                    color: kMainColor, fontWeight: FontWeight.bold),
                borderWidth: 1,
                borderColor: kMainColor,
                unselectedBorderColor: kMainColor,
                radius: 100,
                controller: controllertab,
                tabs: listtab,
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
                                        Text(
                                          "${item['statuskerjaan']}",
                                          style: kTextStyle.copyWith(
                                              color: kAlertColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
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
                                          "${item['sales_user'][1]}",
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
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "${item['agentnya']}",
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
                                        // if (item['stat'] == 'LUNAS') ...[
                                        //   Text(
                                        //     item['stat'].toString(),
                                        //     style: kTextStyle.copyWith(
                                        //         color: kGreenColor,
                                        //         fontSize: 12,
                                        //         fontWeight: FontWeight.bold),
                                        //   ),
                                        // ] else ...[
                                        //   Text(
                                        //     item['stat'].toString(),
                                        //     style: kTextStyle.copyWith(
                                        //         color: kAlertColor,
                                        //         fontSize: 12,
                                        //         fontWeight: FontWeight.bold),
                                        //   ),
                                        // ]
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
        ),
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
      liscabang = body['cabang'];
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
}

class CustomSearchDelegate extends SearchDelegate {
  final List listdata;
  CustomSearchDelegate(this.listdata);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List matchQuery = [];
    for (var fruit in listdata) {
      if (fruit['name'].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add({
          // ignore: prefer_interpolation_to_compose_strings
          'data': 'No.Pro-Forma : #' + fruit['name'],
          'noinv': fruit['name']
        });
      }
    }

    for (var fruit in listdata) {
      if (fruit['partner_id'][1].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add({
          // ignore: prefer_interpolation_to_compose_strings
          'data': 'Customer : ' + fruit['partner_id'][1],
          'noinv': fruit['name']
        });
      }
    }

    for (var fruit in listdata) {
      if (fruit['company_name'].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add({
          // ignore: prefer_interpolation_to_compose_strings
          'data': 'Company : ' + fruit['company_name'],
          'noinv': fruit['name']
        });
      }
    }

    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(
              result['data'],
              style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 12),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ProformaDetails(noinv: result['noinv'])));
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List matchQuery = [];
    for (var fruit in listdata) {
      if (fruit['name'].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add({
          // ignore: prefer_interpolation_to_compose_strings
          'data': 'No.Pro-Forma : #' + fruit['name'],
          'noinv': fruit['name']
        });
      }
    }

    for (var fruit in listdata) {
      if (fruit['partner_id'][1].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add({
          // ignore: prefer_interpolation_to_compose_strings
          'data': 'Customer : ' + fruit['partner_id'][1],
          'noinv': fruit['name']
        });
      }
    }

    for (var fruit in listdata) {
      if (fruit['company_name'].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add({
          // ignore: prefer_interpolation_to_compose_strings
          'data': 'Company : ' + fruit['company_name'],
          'noinv': fruit['name']
        });
      }
    }

    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return InkWell(
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 10.0, bottom: 10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            // ignore: prefer_interpolation_to_compose_strings
                            result['data'],
                            style: kTextStyle.copyWith(
                                color: kTitleColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ])),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ProformaDetails(noinv: result['noinv'])));
            },
          );
        });
  }
}
