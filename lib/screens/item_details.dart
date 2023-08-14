import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:login_signup/models/recordDto.dart';
import 'package:login_signup/services/app_services.dart';

import '../config/appconfig.dart';
import '../models/categoryListDto.dart';
import '../models/vendorListDto.dart';

class ItemDetailsPage extends StatefulWidget {
  const ItemDetailsPage({Key? key, required this.id}) : super(key: key);
  final int id;
  static RecordDto recordDto = RecordDto();

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState(id);
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  // late List data; //edited line
  var _selectedTxnStat;
  var _selectedItemName;
  var _selectedTxnType;
  var _selectedVendor;

  final _itemDateCtrl = TextEditingController();
  final _itemNameCtrl = TextEditingController();
  final _vendorNameCtrl = TextEditingController();
  final _txnTypeCtrl = TextEditingController();
  final _txnStatCtrl = TextEditingController();
  final _amtCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  List txnStat = ['Perbelanjaan', 'Pendapatan'];
  List txnOption = ['FPX', 'CASH', 'LAIN-LAIN'];
  ValueNotifier<List<CategoryListDto>> catlist = ValueNotifier([]);
  ValueNotifier<List<VendorListDto>> vendorlist = ValueNotifier([]);

  var id;
  _ItemDetailsPageState(this.id);

  _confirmDelete(int id) {
    showCupertinoDialog(context: context, builder: showDialog);
    setState(() {
      this.id = id;
    });
    log(id.toString());
  }

  Widget showDialog(BuildContext context) => CupertinoAlertDialog(
        title: Text('Sila Sahkan',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                fontFamily: "Sans")),
        content: Column(
          children: [
            Text('Adakah anda pasti untuk memadam rekod ini?',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w300,
                    fontFamily: "Sans")),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: Text('Ya, Sila Padam',
                style: TextStyle(
                    // color: Colors.black,
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Sans")),
            onPressed: () {
              deleteRecord(id, context);
            },
          ),
          CupertinoDialogAction(
            child: Text('Batal',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Sans")),
            onPressed: () => Navigator.pop(context),
          )
        ],
      );

  init() async {
    callRecordDataById(id);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _confirmDelete(id);
          },
          label: const Text(
            'Hapus',
            style: TextStyle(
              fontFamily: "Lemon",
              fontWeight: FontWeight.bold,
              fontSize: 13.0,
            ),
          ),
          icon: const Icon(Icons.delete),
          backgroundColor: Colors.red,
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Butiran Maklumat Rekod",
            style: TextStyle(
                fontFamily: "Lemon",
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                color: Colors.black87),
          ),
          elevation: 0.2,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 500,
                width: double.infinity,
                color: Colors.white,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Tarikh Direkod :',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Sans",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(ItemDetailsPage.recordDto.createdAt ?? ''),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Nama Item :',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Sans",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(ItemDetailsPage.recordDto.itemName ?? ''),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Status Item :',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Sans",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(ItemDetailsPage.recordDto.itemStat ?? ''),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Jenis Transaksi :',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Sans",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(ItemDetailsPage.recordDto.itemType ?? ''),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Jumlah Amaun Item :',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Sans",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(ItemDetailsPage.recordDto.itemAmt.toString()),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Nama Vendor :',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Sans",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(ItemDetailsPage.recordDto.vendorName ?? 'Tiada'),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Keterangan Item :',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Sans",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(ItemDetailsPage.recordDto.desc ?? 'Tiada'),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }
}
