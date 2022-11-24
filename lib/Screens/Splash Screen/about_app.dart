// ignore_for_file: deprecated_member_use

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String tokedata = '';
  List<String> leveladmin = <String>['4'];

  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var levelnya =
        localStorage.getString('level').toString().replaceAll('"', '');
    if (leveladmin.contains(levelnya)) {
      setState(() {
        tokedata = fcmToken!;
      });
    }

    debugPrint('--------------------------------------------------');
    debugPrint('TOKEN :  $fcmToken');
    debugPrint('--------------------------------------------------');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 4.5,
            ),
            const Image(
              image: AssetImage('images/round_logo.png'),
              width: 200,
              height: 200,
            ),
            Text(
              'RuangOffice.com',
              style: GoogleFonts.manrope(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0),
            ),
            const Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Version 1.0.4',
                  style: GoogleFonts.manrope(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SelectableText(
                  tokedata,
                  showCursor: true,
                  toolbarOptions: const ToolbarOptions(
                      copy: true, selectAll: true, cut: false, paste: false),
                  style: GoogleFonts.manrope(
                      color: kAlertColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
