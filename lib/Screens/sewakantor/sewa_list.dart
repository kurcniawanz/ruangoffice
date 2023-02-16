import 'dart:convert';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../../network/api.dart';
import 'sewa_add.dart';
import 'sewa_detail.dart';

class SewaList extends StatefulWidget {
  const SewaList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SewaListState createState() => _SewaListState();
}

class _SewaListState extends State<SewaList> with TickerProviderStateMixin {
  List listdata = [];
  String ketdata = '';

  late TabController controllertab;

  List<Widget> listtab = [
    const Tab(
      text: "  DRAFT  ",
    ),
    const Tab(
      text: "  ONGOING  ",
    ),
    const Tab(
      text: "  EXPIRED  ",
    ),
    const Tab(
      text: "     All     ",
    ),
  ];

  @override
  void initState() {
    super.initState();

    controllertab = TabController(length: listtab.length, vsync: this);
    controllertab.addListener(() {
      if (controllertab.index == 0) {
        _getpaketdata('draft');
      } else if (controllertab.index == 1) {
        _getpaketdata('ongoing');
      } else if (controllertab.index == 2) {
        _getpaketdata('expired');
      } else if (controllertab.index == 3) {
        _getpaketdata('%');
      }
    });

    _getpaketdata('draft');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => const SewaAdd().launch(context),
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
          'List Sewa Kantor',
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
                                        const Spacer(),
                                        Text(
                                          'Free meeting ${item['sisa_meeting']} jam',
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
                                          item['product_nama'].toString(),
                                          style: kTextStyle.copyWith(
                                              color: kGreyTextColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        if (item['state'] == '1') ...[
                                          Text(
                                            'Draft',
                                            style: kTextStyle.copyWith(
                                                color: kMainColorlama,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ] else if (item['state'] == '2') ...[
                                          Text(
                                            'Ongoing',
                                            style: kTextStyle.copyWith(
                                                color: kGreenColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ] else ...[
                                          Text(
                                            'Expired',
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
        ),
      ),
    );
  }

  Future<void> _getpaketdata(String kodenya) async {
    EasyLoading.show(status: 'loading...');
    setState(() {
      ketdata = 'sedang mengambil data...';
    });

    var data = {"id": kodenya};
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
      if (fruit['product_nama'].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add({
          // ignore: prefer_interpolation_to_compose_strings
          'data': 'Product: #' + fruit['product_nama'],
          'name': fruit['name'],
          'id': fruit['id']
        });
      }
    }

    for (var fruit in listdata) {
      if (fruit['partner_id'][1].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add({
          // ignore: prefer_interpolation_to_compose_strings
          'data': 'Customer : ' + fruit['partner_id'][1],
          'name': fruit['name'],
          'id': fruit['id']
        });
      }
    }

    for (var fruit in listdata) {
      if (fruit['company_name'].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add({
          // ignore: prefer_interpolation_to_compose_strings
          'data': 'Company : ' + fruit['company_name'],
          'name': fruit['name'],
          'id': fruit['id']
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
                      SewaDetails(idsewa: result['id'].toString())));
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List matchQuery = [];
    for (var fruit in listdata) {
      if (fruit['product_nama'].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add({
          // ignore: prefer_interpolation_to_compose_strings
          'data': 'Product: #' + fruit['product_nama'],
          'name': fruit['name'],
          'id': fruit['id']
        });
      }
    }

    for (var fruit in listdata) {
      if (fruit['partner_id'][1].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add({
          // ignore: prefer_interpolation_to_compose_strings
          'data': 'Customer : ' + fruit['partner_id'][1],
          'name': fruit['name'],
          'id': fruit['id']
        });
      }
    }

    for (var fruit in listdata) {
      if (fruit['company_name'].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add({
          // ignore: prefer_interpolation_to_compose_strings
          'data': 'Company : ' + fruit['company_name'],
          'name': fruit['name'],
          'id': fruit['id']
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
                      SewaDetails(idsewa: result['id'].toString())));
            },
          );
        });
  }
}
