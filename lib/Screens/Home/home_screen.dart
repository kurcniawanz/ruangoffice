import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:badges/badges.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../constant.dart';
// import '../../network/api.dart';
import '../Splash Screen/about_app.dart';
import '../invoice/invoice_list.dart';
import '../paket/paket_list.dart';
import '../product/product_list.dart';
import '../sewakantor/sewa_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String actualDate = DateFormat("dd MMMM yyyy").format(DateTime.now());
  String nameprofilile = "";
  String sisagaji = "";
  String totalkasbon = "";
  String profile = "";
  String nomorstaff = "";
  String level = "";
  String tglgaji = "";
  String pokok = "";
  List<String> levels = <String>['1', '2', '3', '4'];
  List<String> leveladmin = <String>['3', '4'];

  String notifpaket = '0';
  String notifall = '0';
  String mobile = '-';
  String alarmAudioPath = "audio/reminder_sound.mp3";
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    getDatatoken();
    player = AudioPlayer();

    // aplikasi kondisi mati
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        var dataroute = value.data['route'];
        Navigator.of(context).pushNamed(dataroute);
        debugPrint('on mati ====== ${value.notification!.title}');
        playysound();

        // if (_dataroute == '/home') {
        //   const HomeScreen().launch(context);
        // } else if (_dataroute == '/pagetugas') {
        //   const OutworkList().launch(context);
        // } else if (_dataroute == '/pagekasbon') {
        //   const LoanList().launch(context);
        // } else if (_dataroute == '/pagegaji') {
        //   const SalaryStatementList().launch(context);
        // } else if (_dataroute == '/reminder') {
        //   const ReminderList().launch(context);
        // }

        // if (_dataroute == '/home') {
        //   const HomeScreen().launch(context);
        // } else if (_dataroute == '/pagetugas') {
        //   const OutworkList().launch(context);
        // } else if (_dataroute == '/pagekasbon') {
        //   const LoanList().launch(context);
        // } else if (_dataroute == '/pagegaji') {
        //   const SalaryStatementList().launch(context);
        // } else if (_dataroute == '/reminder') {
        //   const ReminderList().launch(context);
        // }
      }
    });

    // aplikasi kondisi background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (event.notification != null) {
        var dataroute = event.data['route'];
        Navigator.of(context).pushNamed(dataroute);

        debugPrint('on background ====== ${event.notification!.title}');
        playysound();
      }
    });

    // aplikasi kondisi nyala
    FirebaseMessaging.onMessage.listen((event) {
      if (event.notification != null) {
        debugPrint('on nyala: ${event.notification!.title}');
        getDatatoken();
        playysound();
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: showExitPopup,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: kMainColor,
          appBar: AppBar(
            backgroundColor: kMainColor,
            elevation: 0.0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: ListTile(
              contentPadding: EdgeInsets.zero,
              // leading: CircleAvatar(
              //   radius: 20.0,
              //   backgroundImage: MemoryImage(
              //     convertBase64Image(profile),
              //   ),
              // ).onTap(() {
              //   getDatatoken();
              // }),
              title: Text(
                nameprofilile,
                style: kTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                mobile,
                style: kTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w100),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                child: Badge(
                  position: BadgePosition.topStart(),
                  badgeContent: Text(
                    notifall,
                    style: kTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w800),
                  ),
                  child: const Image(
                    image: AssetImage('images/bell.png'),
                    width: 35,
                    height: 35,
                  ).onTap(() {
                    getDatatoken();
                  }),
                ),
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                Container(
                  height: context.height() / 2.4,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0)),
                    color: kMainColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: context.height() / 4,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0)),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              // CircleAvatar(
                              //   radius: 60.0,
                              //   backgroundColor: kMainColor,
                              //   backgroundImage: MemoryImage(
                              //     convertBase64Image(profile),
                              //   ),
                              // ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Text(
                                nameprofilile,
                                style: kTextStyle.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ).onTap(() {
                            getDatatoken();
                          }),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 10.0,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     SizedBox(
                      //       width: 100,
                      //       child: Text(
                      //         'Tgl.Gajian  : ',
                      //         textAlign: TextAlign.right,
                      //         style: kTextStyle.copyWith(
                      //             color: Colors.white,
                      //             fontSize: 12.0,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 100,
                      //       child: Text(
                      //         "  $tglgaji",
                      //         textAlign: TextAlign.left,
                      //         style: kTextStyle.copyWith(
                      //             color: Colors.white,
                      //             fontSize: 12.0,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 5.0,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     SizedBox(
                      //       width: 100,
                      //       child: Text(
                      //         'Gaji Pokok  : ',
                      //         textAlign: TextAlign.right,
                      //         style: kTextStyle.copyWith(
                      //             color: Colors.greenAccent,
                      //             fontSize: 12.0,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 100,
                      //       child: Text(
                      //         '  Rp. ${formatAmount(pokok)}',
                      //         textAlign: TextAlign.left,
                      //         style: kTextStyle.copyWith(
                      //             color: Colors.greenAccent,
                      //             fontSize: 12.0,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 5.0,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     SizedBox(
                      //       width: 100,
                      //       child: Text(
                      //         'Kasbon  : ',
                      //         textAlign: TextAlign.right,
                      //         style: kTextStyle.copyWith(
                      //             color: Colors.yellow,
                      //             fontSize: 12.0,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 100,
                      //       child: Text(
                      //         '  Rp. ${formatAmount(totalkasbon)}',
                      //         textAlign: TextAlign.left,
                      //         style: kTextStyle.copyWith(
                      //             color: Colors.yellow,
                      //             fontSize: 12.0,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 5.0,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     SizedBox(
                      //       width: 100,
                      //       child: Text(
                      //         'Potongan  : ',
                      //         textAlign: TextAlign.right,
                      //         style: kTextStyle.copyWith(
                      //             color: Colors.yellow,
                      //             fontSize: 12.0,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 100,
                      //       child: Text(
                      //         '  Rp. 0',
                      //         textAlign: TextAlign.left,
                      //         style: kTextStyle.copyWith(
                      //             color: Colors.yellow,
                      //             fontSize: 12.0,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 5.0,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     SizedBox(
                      //       width: 100,
                      //       child: Text(
                      //         'Sisa Gaji  : ',
                      //         textAlign: TextAlign.right,
                      //         style: kTextStyle.copyWith(
                      //             color: Colors.greenAccent,
                      //             fontSize: 12.0,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 100,
                      //       child: Text(
                      //         '  Rp. ${formatAmount(sisagaji)}',
                      //         textAlign: TextAlign.left,
                      //         style: kTextStyle.copyWith(
                      //             color: Colors.greenAccent,
                      //             fontSize: 12.0,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () => const AboutScreen().launch(context),
                  title: Text(
                    'About App',
                    style: kTextStyle.copyWith(color: kTitleColor),
                  ),
                  leading: const Icon(
                    FeatherIcons.alertTriangle,
                    color: kMainColor,
                  ),
                ),
                ListTile(
                  title: Text(
                    'Logout',
                    style: kTextStyle.copyWith(color: kTitleColor),
                  ),
                  leading: const Icon(
                    FeatherIcons.logOut,
                    color: kMainColor,
                  ),
                  onTap: () {
                    _logoutt();
                  },
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(child: _materialproduct()),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Expanded(child: _materialinvoice()),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Expanded(child: _materialsewa()),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Expanded(child: _materialpaket()),
                        ],
                      ),
                      const SizedBox(
                        height: 450.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Material _materialinvoice() {
    Material dataresult;

    dataresult = Material(
      elevation: 2.0,
      child: GestureDetector(
        onTap: () {
          const KerjaList().launch(context);
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
              const Center(
                child: Image(
                  image: AssetImage('images/sewakantor.png'),
                  height: 100,
                ),
              ),
              Center(
                child: Text(
                  'Invoice',
                  style: kTextStyle.copyWith(
                      color: kTitleColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return dataresult;
  }

  Material _materialproduct() {
    Material dataresult;

    dataresult = Material(
      elevation: 2.0,
      child: GestureDetector(
        onTap: () {
          const ProductList().launch(context);
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
              const Center(
                child: Image(
                  image: AssetImage('images/sewakantor.png'),
                  height: 100,
                ),
              ),
              Center(
                child: Text(
                  'Product',
                  style: kTextStyle.copyWith(
                      color: kTitleColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return dataresult;
  }

  Material _materialsewa() {
    Material dataresult;

    dataresult = Material(
      elevation: 2.0,
      child: GestureDetector(
        onTap: () {
          const SewaList().launch(context);
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
              const Center(
                child: Image(
                  image: AssetImage('images/sewakantor.png'),
                  height: 100,
                ),
              ),
              Center(
                child: Text(
                  'Sewa Kantor',
                  style: kTextStyle.copyWith(
                      color: kTitleColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return dataresult;
  }

  Material _materialpaket() {
    Material dataresult;
    if (notifpaket != '0') {
      dataresult = Material(
        elevation: 2.0,
        child: GestureDetector(
          onTap: () {
            const PaketList().launch(context);
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
                Center(
                  child: Badge(
                    position: BadgePosition.topStart(),
                    badgeContent: Text(notifpaket,
                        style: const TextStyle(color: Colors.white)),
                    child: const Image(
                      image: AssetImage('images/paket.png'),
                      height: 100,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Paket',
                    maxLines: 2,
                    style: kTextStyle.copyWith(
                        color: kTitleColor, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      dataresult = Material(
        elevation: 2.0,
        child: GestureDetector(
          onTap: () {
            const PaketList().launch(context);
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
                const Center(
                  child: Image(
                    image: AssetImage('images/paket.png'),
                    height: 100,
                  ),
                ),
                Center(
                  child: Text(
                    'Paket',
                    maxLines: 2,
                    style: kTextStyle.copyWith(
                        color: kTitleColor, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    return dataresult;
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'RuangOffice.com',
              style: kTextStyle.copyWith(color: kTitleColor, fontSize: 14),
            ),
            content: const SizedBox(
              width: 150,
              height: 40,
              child: Center(child: Text('Yakin keluar Aplikasi ?')),
            ),
            actions: [
              SizedBox(
                width: 60,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAlertColor,
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: const Text('No'),
                ),
              ),
              SizedBox(
                width: 60,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreenColor,
                  ),
                  onPressed: () => SystemNavigator.pop(),
                  //return true when click on "Yes"
                  child: const Text('Yes'),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _logoutt() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'RuangOffice.com',
              style: kTextStyle.copyWith(color: kTitleColor, fontSize: 14),
            ),
            content: const SizedBox(
              width: 150,
              height: 40,
              child: Center(child: Text('Yakin Log Out ?')),
            ),
            actions: [
              SizedBox(
                width: 60,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAlertColor,
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: const Text('No'),
                ),
              ),
              SizedBox(
                width: 60,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreenColor,
                  ),
                  onPressed: () => {_deleteAll(), SystemNavigator.pop()},
                  //return true when click on "Yes"
                  child: const Text('Yes'),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deleteAll() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('nomor');
    localStorage.remove('name');
    localStorage.remove('level');
    localStorage.remove('no_rek');
    localStorage.remove('user');
    localStorage.remove('pass');
    localStorage.remove('tokenupdate');
  }

  Future<void> playysound() async {
    debugPrint('--------------> ');

    await player.setAsset('audio/reminder_sound.mp3');
    player.play();

    debugPrint('--------------x ');
  }

  Future<void> getDatatoken() async {
    imageCache.clear();

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var namaa = localStorage.getString('name').toString().replaceAll('"', '');
    var levelnya =
        localStorage.getString('level_id').toString().replaceAll('"', '');
    var nomobile =
        localStorage.getString('mobile').toString().replaceAll('"', '');
    var notiff = localStorage.getString('notif').toString().replaceAll('"', '');
    setState(() {
      level = levelnya;
      nameprofilile = namaa;
      mobile = nomobile;
      notifall = notiff;
    });
  }

  Uint8List convertBase64Image(String base64String) {
    return const Base64Decoder().convert(base64String);
  }
}
