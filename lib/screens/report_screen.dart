import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Laporan",
            style: TextStyle(
                fontFamily: "Lemon",
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                color: Colors.black87),
          ),
          elevation: 0.2,
        ),
        body: Column(
          children: [],
        ));
  }
}
