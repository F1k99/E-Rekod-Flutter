import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:login_signup/screens/dashboard_screen.dart';
import 'package:login_signup/screens/login_screen.dart';
import 'package:login_signup/screens/report_screen.dart';
import 'package:login_signup/screens/setting_screen.dart';
import 'package:login_signup/theme.dart';
import 'package:login_signup/widgets/primary_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/recordListDto.dart';

class NavigationScreen extends StatefulWidget {
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int current_index = 0;
  final List<Widget> pages = [
    DashboardPage(),
    ReportPage(),
    SettingPage(),
  ];

  void OnTapped(int index) {
    setState(() {
      current_index = index;
    });
  }
  // int index = 0;
  // final screens = [DashboardPage(), ReportPage(), SettingPage()];

  // Future<void> logoutUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.clear();
  // }

  // init() async {
  //   log('test');
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   init();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[current_index],
      bottomNavigationBar: Stack(
        children: [
          Container(
            height: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Color.fromARGB(255, 193, 209, 240),
                  iconSize: 20.0,
                  selectedIconTheme: IconThemeData(size: 28.0),
                  selectedItemColor: primaryBlue,
                  unselectedItemColor: Colors.black,
                  selectedFontSize: 16.0,
                  unselectedFontSize: 12,
                  currentIndex: current_index,
                  onTap: OnTapped,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.analytics),
                      label: "Laporan",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: "Tetapan",
                    ),
                  ]),
            ),
          ),
        ],
        // child: Container(
        //   height: 70,
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        //     child: BottomNavigationBar(
        //         type: BottomNavigationBarType.fixed,
        //         backgroundColor: Color.fromARGB(255, 193, 209, 240),
        //         iconSize: 20.0,
        //         selectedIconTheme: IconThemeData(size: 28.0),
        //         selectedItemColor: primaryBlue,
        //         unselectedItemColor: Colors.black,
        //         selectedFontSize: 16.0,
        //         unselectedFontSize: 12,
        //         currentIndex: current_index,
        //         onTap: OnTapped,
        //         items: <BottomNavigationBarItem>[
        //           BottomNavigationBarItem(
        //             icon: Icon(Icons.home),
        //             label: "Home",
        //           ),
        //           BottomNavigationBarItem(
        //             icon: Icon(Icons.analytics),
        //             label: "Laporan",
        //           ),
        //           BottomNavigationBarItem(
        //             icon: Icon(Icons.settings),
        //             label: "Tetapan",
        //           ),
        //         ]),
        //   ),
        // ),
      ),
      // body: screens[index],
      // bottomNavigationBar: NavigationBarTheme(
      //   data: NavigationBarThemeData(indicatorColor: Colors.blueGrey.shade100),
      //   child: NavigationBar(
      //       backgroundColor: Colors.white,
      //       onDestinationSelected: (index) =>
      //           setState(() => this.index = index),
      //       height: 60,
      //       selectedIndex: index,
      //       destinations: [
      //         NavigationDestination(icon: Icon(Icons.home), label: 'Utama'),
      //         NavigationDestination(
      //             icon: Icon(Icons.analytics), label: 'Laporan'),
      //         NavigationDestination(
      //             icon: Icon(Icons.settings), label: 'Tetapan'),
      //       ]),
      // ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       SizedBox(
      //         height: 30,
      //       ),
      //       // Container(
      //       //   width: 220,
      //       //   child: CustomPrimaryButton(
      //       //     buttonColor: Colors.red.shade700,
      //       //     textValue: 'Log Out',
      //       //     textColor: Colors.white,
      //       //     onPressed: () async {
      //       //       await logoutUser();
      //       //     },
      //       //   ),
      //       // )
      //     ],
      //   ),
      // ),
    );
  }
}
