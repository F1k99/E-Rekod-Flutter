import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:login_signup/screens/bottom_nav_bar.dart';
import 'package:login_signup/widgets/input_field.dart';

import '../config/appconfig.dart';
import '../services/app_services.dart';
import '../theme.dart';
import '../widgets/primary_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  static final TextEditingController nameController =
      TextEditingController(text: '');
  static final TextEditingController emailController =
      TextEditingController(text: '');
  static final TextEditingController passwordController =
      TextEditingController(text: '');
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool passwordVisible = false;
  bool passwordConfrimationVisible = false;
  bool isChecked = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    navigateUser();
  }

  void navigateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    print(status);
    if (status) {
      log('logged in');
      // Navigatior.pushReplacement(context, "/Home");
    } else {
      log('logged out');
      // Navigation.pushReplacement(context, "/Login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daftar Akaun',
                    style: heading2.copyWith(color: textBlack),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'assets/images/accent.png',
                    width: 99,
                    height: 4,
                  ),
                ],
              ),
              SizedBox(
                height: 48,
              ),
              Form(
                child: Column(
                  children: [
                    InputField(
                      hintText: 'Nama',
                      controller: RegisterScreen.nameController,
                      suffixIcon: SizedBox(),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    InputField(
                      hintText: 'Emel',
                      controller: RegisterScreen.emailController,
                      suffixIcon: SizedBox(),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    InputField(
                      hintText: 'Katalaluan',
                      controller: RegisterScreen.passwordController,
                      obscureText: !passwordVisible,
                      suffixIcon: IconButton(
                        color: textGrey,
                        splashRadius: 1,
                        icon: Icon(passwordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: togglePassword,
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // GestureDetector(
                  //   onTap: () {
                  //     setState(() {
                  //       isChecked = !isChecked;
                  //     });
                  //   },
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: isChecked ? primaryBlue : Colors.transparent,
                  //       borderRadius: BorderRadius.circular(4.0),
                  //       border: isChecked
                  //           ? null
                  //           : Border.all(color: textGrey, width: 1.5),
                  //     ),
                  //     width: 20,
                  //     height: 20,
                  //     child: isChecked
                  //         ? Icon(
                  //             Icons.check,
                  //             size: 20,
                  //             color: Colors.white,
                  //           )
                  //         : null,
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 12,
                  // ),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       'By creating an account, you agree to our',
                  //       style: regular16pt.copyWith(color: textGrey),
                  //     ),
                  //     Text(
                  //       'Terms & Conditions',
                  //       style: regular16pt.copyWith(color: primaryBlue),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              SizedBox(
                height: 32,
              ),
              CustomPrimaryButton(
                buttonColor: primaryBlue,
                textValue: 'Daftar',
                textColor: Colors.white,
                onPressed: () async {
                  log('register');
                  await register(context);
                },
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sudah Mempunyai Akaun? ",
                    style: regular16pt.copyWith(color: textGrey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    child: Text(
                      'Log Masuk',
                      style: regular16pt.copyWith(color: primaryBlue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
