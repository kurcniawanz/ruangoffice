import 'dart:convert';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../../network/api.dart';
import 'meeting_add.dart';
import 'sewa_detail.dart';

// ignore: must_be_immutable
class MeetingList extends StatefulWidget {
  String idsewa;
  MeetingList({super.key, required this.idsewa});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _MeetingListState createState() => _MeetingListState(idsewa);
}

class _MeetingListState extends State<MeetingList>
    with TickerProviderStateMixin {
  String idsewa;
  _MeetingListState(this.idsewa);
  List listdata = [];
  String ketdata = '';

  late TabController controllertab;

  List<Widget> listtab = [
    const Tab(
      text: "  DRAFT  ",
    ),
    const Tab(
      text: "  CONFIRM  ",
    ),
    const Tab(
      text: "  DONE  ",
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
        _getmeetingdata('draft');
      } else if (controllertab.index == 1) {
        _getmeetingdata('confirm');
      } else if (controllertab.index == 2) {
        _getmeetingdata('done');
      } else if (controllertab.index == 3) {
        _getmeetingdata('%');
      }
    });

    _getmeetingdata('draft');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MeetingAdd(idsewa: idsewa)))
        },
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
          'List Meeting',
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
                                          "Start : ${item['tgl']}",
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
                                          "Finish : ${item['tgl_jt']}",
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
                                          "",
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
                                            'Confirm',
                                            style: kTextStyle.copyWith(
                                                color: kGreenColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ] else ...[
                                          Text(
                                            'Done',
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
                                          "Lama : ${item['lama']} jam",
                                          style: kTextStyle.copyWith(
                                              color: kMainColorlama,
                                              fontSize: 11,
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

  Future<void> _getmeetingdata(String kodenya) async {
    EasyLoading.show(status: 'loading...');
    setState(() {
      ketdata = 'sedang mengambil data...';
    });

    var data = {"id": idsewa, "state": kodenya};
    var res = await Network().auth(data, '/sewa_meeting');
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
