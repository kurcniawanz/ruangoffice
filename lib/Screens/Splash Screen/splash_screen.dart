import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';

import '../Authentication/sign_in.dart';
import '../Home/home_screen.dart';
import '../../constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String tokenupdate = DateFormat("ddMMMMyyyy").format(DateTime.now());
  var email = '';
  var password = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 2));

    defaultBlurRadius = 10.0;
    defaultSpreadRadius = 0.5;

    // ignore: use_build_context_synchronously
    finish(context);

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    debugPrint(localStorage.getString('nomor'));
    debugPrint('============================================');
    if (localStorage.getString('nomor') != null) {
      if (localStorage.getString('tokenupdate') != null) {
        if (localStorage.getString('tokenupdate').toString() != tokenupdate) {
          _logoutt();
        } else {
          var pass1 = localStorage.getString('pass').toString();
          var user1 = localStorage.getString('user').toString();
          setState(() {
            password = pass1;
            email = user1;
          });

          // ignore: use_build_context_synchronously
          const HomeScreen().launch(context);
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'RuangOffice.com',
              style: kTextStyle.copyWith(color: kTitleColor, fontSize: 14),
            ),
            content: const SizedBox(
              width: 150,
              height: 40,
              child: Center(child: Text('Sesi Login Berakhir ?')),
            ),
            actions: [
              SizedBox(
                width: 60,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreenColor,
                  ),
                  onPressed: () => _logoutt(),
                  //return true when click on "Yes"
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      const SignIn().launch(context);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: kMainColor,
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
                  color: kMainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0),
            ),
            const Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Version 1.0.9',
                  style: GoogleFonts.manrope(
                      color: kMainColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
              child: Center(child: Text('Silahkan Log Out ?')),
            ),
            actions: [
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
    localStorage.remove('user');
    localStorage.remove('pass');
    localStorage.remove('level');
  }
}
