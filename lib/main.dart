import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_signup/screens/bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status = prefs.getBool('isLoggedIn') ?? false;
  print(status);
  runApp(
      MaterialApp(home: status == true ? NavigationScreen() : LoginScreen()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Lato',
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
