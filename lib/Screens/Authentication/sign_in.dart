import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import '../../GlobalComponents/button_global.dart';
import '../../constant.dart';
import '../../network/api.dart';
import '../Home/home_screen.dart';
import 'forgot_password.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController controller = TextEditingController();

  final userController = TextEditingController();
  final passControler = TextEditingController();

  bool isChecked = false;
  bool isCheckedsave = false;
  var email = '';
  var password = '';
  String tokenupdate = DateFormat("ddMMMMyyyy").format(DateTime.now());
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    getuserpass();
    // EasyLoading.showSuccess('Use in initState');
  }

  @override
  void dispose() {
    userController.dispose();
    passControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kMainColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'RuangOffice.com',
              style: kTextStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40),
            ),
          ),
          Center(
            child: Text(
              'Sign In now to begin an amazing journey',
              style: kTextStyle.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Container(
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
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 60.0,
                    child: AppTextField(
                      controller: userController,
                      textFieldType: TextFieldType.EMAIL,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'e.g aaa@mail.com',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  AppTextField(
                    controller: passControler,
                    textFieldType: TextFieldType.PASSWORD,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: kTextStyle,
                      hintText: 'Enter password',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: isCheckedsave,
                          activeColor: kMainColor,
                          thumbColor: kGreyTextColor,
                          onChanged: (bool value) {
                            setState(() {
                              isCheckedsave = value;
                            });

                            debugPrint(isCheckedsave.toString());
                          },
                        ),
                      ),
                      Text(
                        'Save Me',
                        style: kTextStyle,
                      ),
                      const Spacer(),
                      Text(
                        'Forgot Password?',
                        style: kTextStyle,
                      ).onTap(() {
                        const ForgotPassword().launch(context);
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ButtonGlobal(
                    buttontext: 'Sign In',
                    buttonDecoration:
                        kButtonDecoration.copyWith(color: kMainColor),
                    onPressed: () {
                      _login();
                      // const HomeScreen().launch(context);
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  // RichText(
                  //   text: TextSpan(
                  //     children: [
                  //       TextSpan(
                  //         text: 'Don\'t have an account? ',
                  //         style: kTextStyle.copyWith(
                  //           color: kGreyTextColor,
                  //         ),
                  //       ),
                  //       WidgetSpan(
                  //         child: Text(
                  //           'Sign Up',
                  //           style: kTextStyle.copyWith(
                  //             fontWeight: FontWeight.bold,
                  //             color: kMainColor,
                  //           ),
                  //         ).onTap(() {
                  //           const SignUp().launch(context);
                  //         }),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (isChecked == false) {
      EasyLoading.show(status: 'loading...');
      setState(() {
        isChecked = true;
      });

      var data = {'username': email, 'password': password};
      var res = await Network().auth(data, '/api_login');
      var body = json.decode(res.body);

      debugPrint('TOKEN :  $body');
      debugPrint('--------------------------------------------------');

      if (body.length >= 1) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('iduser', json.encode(body[0]["id"]));
        localStorage.setString('name', json.encode(body[0]["name"]));
        localStorage.setString('level_id', json.encode(body[0]["level_id"]));
        localStorage.setString('mobile', json.encode(body[0]["mobile"]));
        localStorage.setString(
            'cabang', json.encode(body[0]["industry_id"][1]));
        localStorage.setString('user', email);
        localStorage.setString('pass', password);
        localStorage.setString('tokenupdate', tokenupdate);

        if (isCheckedsave == true) {
          localStorage.setString('user_save', email);
          localStorage.setString('pass_save', password);
        }

        final fcmToken = await FirebaseMessaging.instance.getToken();
        // var datatoken = {
        //   'kode': json.encode(body[0]["id"]).replaceAll('"', ''),
        //   'token': fcmToken
        // };
        // await Network().auth(datatoken, '/api_send_token');

        // debugPrint('--------------------------------------------------');
        // debugPrint('DATA :  $datatoken');
        debugPrint('--------------------------------------------------');
        debugPrint('TOKEN :  $fcmToken');
        debugPrint('--------------------------------------------------');

        EasyLoading.dismiss();
        setState(() {
          isChecked = false;
        });
        // ignore: use_build_context_synchronously
        const HomeScreen().launch(context);
      } else {
        EasyLoading.dismiss();
        setState(() {
          isChecked = false;
        });
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(
              'RuangOffice.com',
              style: kTextStyle.copyWith(color: kTitleColor, fontSize: 14),
            ),
            content: const SizedBox(
              width: 150,
              height: 40,
              child: Center(child: Text('Username/Password salah.')),
            ),
            actions: [
              SizedBox(
                width: 60,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAlertColor,
                  ),
                  onPressed: () => Navigator.pop(context, 'OK'),
                  //return false when click on "NO"
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> getuserpass() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userr =
        localStorage.getString('user_save').toString().replaceAll('"', '');
    var passr =
        localStorage.getString('pass_save').toString().replaceAll('"', '');

    // ignore: unnecessary_null_comparison
    if (localStorage.getString('user_save') != null) {
      userController.text = userr;
      passControler.text = passr;
      setState(() {
        isCheckedsave = true;
        email = userr;
        password = passr;
      });
    } else {
      userController.text = "";
      passControler.text = "";
      setState(() {
        isCheckedsave = false;
        email = "";
        password = "";
      });
    }
  }
}
