import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_signup/screens/bottom_nav_bar.dart';
import 'package:login_signup/screens/register_screen.dart';
import 'package:login_signup/widgets/custom_checkbox.dart';
import 'package:login_signup/widgets/input_field.dart';
import 'package:login_signup/widgets/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/appconfig.dart';
import '../theme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  static final TextEditingController emailController =
      TextEditingController(text: '');
  static final TextEditingController passwordController =
      TextEditingController(text: '');
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
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
  void initState() {
    super.initState();
    init();
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
                    'Log Masuk Ke Akaun\nAnda',
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
                      hintText: 'Emel',
                      suffixIcon: SizedBox(),
                      controller: LoginScreen.emailController,
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    InputField(
                      hintText: 'Katalaluan',
                      controller: LoginScreen.passwordController,
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
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 64, 0, 0),
                child: CustomPrimaryButton(
                  buttonColor: primaryBlue,
                  textValue: 'Log Masuk',
                  textColor: Colors.white,
                  onPressed: () async {
                    // log('login clicked');
                    // await login();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigationScreen(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 90, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Tidak Mempunyai Akaun? ",
                      style: regular16pt.copyWith(color: textGrey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()));
                      },
                      child: Text(
                        'Daftar',
                        style: regular16pt.copyWith(color: primaryBlue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
