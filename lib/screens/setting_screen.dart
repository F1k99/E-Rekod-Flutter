import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_signup/models/userDto.dart';
import 'package:login_signup/models/vendorListDto.dart';
import 'package:login_signup/screens/userlist_screen.dart';
import 'package:login_signup/screens/vendorlist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/appconfig.dart';
import '../models/profileDto.dart';
import '../services/app_services.dart';
import '../widgets/primary_button.dart';
import 'categorylist_screen.dart';
import 'package:http/http.dart' as http;

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  static ProfileDto profileDto = ProfileDto();

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final storage = const FlutterSecureStorage();

  Future<void> logoutUser() async {
    await storage.delete(key: 'jwt');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  init() async {
    await fetchProfile().then((response) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),

      ///
      /// Appbar
      ///
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Tetapan",
          style: TextStyle(
              fontFamily: "Lemon",
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
              color: Colors.black87),
        ),
        elevation: 0.2,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ///
            /// This is card box for profile
            ///
            _cardProfile(),
            SizedBox(
              height: 10.0,
            ),

            _cardAnother()
          ],
        ),
      ),
    );
  }

  var _txtStyleTitle = TextStyle(
      color: Colors.black54, fontWeight: FontWeight.w700, fontSize: 15.0);

  var _txtStyleDeskripsi =
      TextStyle(color: Colors.black26, fontWeight: FontWeight.w400);

  Widget _cardProfile() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15.0,
                  spreadRadius: 0.0)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 180.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)),
                      gradient: LinearGradient(
                          colors: [Color(0xFF3FCE98), Color(0xFF76EE93)])),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Column(
                      children: <Widget>[
                        // Container(
                        //   height: 60.0,
                        //   width: 60.0,
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     image: DecorationImage(
                        //         image:
                        //             AssetImage("assets/avatars/avatar-1.jpg"),
                        //         fit: BoxFit.cover),
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(50.0)),
                        //   ),
                        // ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          SettingPage.profileDto.name.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "Popins",
                              letterSpacing: 1.5,
                              fontSize: 18.0),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          SettingPage.profileDto.email.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontFamily: "Sans",
                              fontSize: 17.0),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          SettingPage.profileDto.role.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Sans",
                              fontSize: 15.0),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Maklumat Akaun",
                    style: _txtStyleTitle,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "Menu untuk menukar maklumat akaun anda",
                    style: _txtStyleDeskripsi,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  _line(),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "Tukar Katalaluan",
                    style: _txtStyleTitle,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text("Menu untuk menukar katalaluan",
                      style: _txtStyleDeskripsi),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardAnother() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15.0,
                  spreadRadius: 0.0)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Lain-lain",
                  style: _txtStyleTitle.copyWith(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
              SizedBox(
                height: 25.0,
              ),
              _line(),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                  splashColor: Colors.blueGrey.shade100,
                  onTap: () {
                    log('message');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserListScreen()),
                    );
                  },
                  child:
                      Text("Tetapan Senarai Pengguna", style: _txtStyleTitle)),
              SizedBox(
                height: 20.0,
              ),
              _line(),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                  splashColor: Colors.blueGrey.shade100,
                  onTap: () {
                    log('message');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VendorListScreen()),
                    );
                  },
                  child: Text("Tetapan Senarai Vendor", style: _txtStyleTitle)),
              SizedBox(
                height: 20.0,
              ),
              _line(),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                  splashColor: Colors.blueGrey.shade100,
                  onTap: () {
                    log('message');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CategoryListScreen()),
                    );
                  },
                  child:
                      Text("Tetapan Senarai Kategori", style: _txtStyleTitle)),
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: Container(
                  width: 150,
                  height: 40,
                  child: CustomPrimaryButton(
                    buttonColor: Colors.red.shade700,
                    textValue: 'Log Keluar',
                    textColor: Colors.white,
                    onPressed: () async {
                      await logoutUser();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _line() {
    return Container(
      height: 1.5,
      width: double.infinity,
      color: Colors.black12.withOpacity(0.03),
    );
  }
}
