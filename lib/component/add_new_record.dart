import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_signup/theme.dart';

import '../models/categoryListDto.dart';
import '../models/recordListDto.dart';
import '../models/vendorListDto.dart';
import '../screens/dashboard_screen.dart';
import '../services/app_services.dart';

class NewRecordWidget extends StatefulWidget {
  const NewRecordWidget({Key? key}) : super(key: key);
  static ValueNotifier<List<CategoryListDto>> catlist = ValueNotifier([]);
  static ValueNotifier<List<VendorListDto>> vendorlist = ValueNotifier([]);

  static var selectedTxnStat;
  static var selectedItemName;
  static var selectedTxnType;
  static var selectedVendor;

  static var itemDateCtrl = TextEditingController();
  static var itemNameCtrl = TextEditingController();
  static var vendorNameCtrl = TextEditingController();
  static var txnTypeCtrl = TextEditingController();
  static var txnStatCtrl = TextEditingController();
  static var amtCtrl = TextEditingController();
  static var dateCtrl = TextEditingController();
  static var descCtrl = TextEditingController();

  @override
  State<NewRecordWidget> createState() => _NewRecordWidgetState();
}

class _NewRecordWidgetState extends State<NewRecordWidget> {
  List txnStat = ['Perbelanjaan', 'Pendapatan'];
  List txnOption = ['FPX', 'CASH', 'LAIN-LAIN'];

  int i = 0;
  var isLoaded = false;
  var exp = 0;
  var inc = 0;
  var strt = 0;
  var bal = 0;
  var id = 0;

  // late List data; //edited line

  final storage = const FlutterSecureStorage();

  init() async {
    await getRecordList().then((response) {
      setState(() {});
    });

    await fetchAcc().then((response) {
      setState(() {});
    });
    // perlu masukkan ke atas sbab ni method lama
    await getAccDetails().then((response) {
      setState(() {
        exp = DashboardPage.accDto.exp!;
        inc = DashboardPage.accDto.inc!;
        strt = DashboardPage.accountdto.value[0].startingAmt!;
        bal = strt + inc - exp;
      });
    });

    await getCategoryList().then((response) {
      setState(() {});
    });

    await getVendorList().then((response) {
      setState(() {});
    });

    getToken();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  getToken() async {
    var value = await storage.read(key: 'jwt');
    log('token :');
    log(value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Container(
        width: double.infinity,
        height: 600,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text('Tambah Rekod',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Sans")),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  //TRANSACTION STATUS DROPDOWN
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            hint: Text(
                              'Sila Pilih Status Transaksi',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Sans"),
                            ),
                            autofocus: false,
                            elevation: 2,
                            borderRadius: BorderRadius.circular(0),
                            items: txnStat
                                .map((item) => DropdownMenuItem(
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: "Sans"),
                                      ),
                                      value: item,
                                    ))
                                .toList(),
                            onChanged: (item) => setState(() {
                              DashboardPage.selectedTxnStat = item;
                            }),
                            onSaved: (value) {
                              setState(() {
                                DashboardPage.selectedTxnStat = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ITEM SELECTION DROPDOWN
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      width: double.infinity,
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            hint: Text(
                              'Sila Pilih Item',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Sans"),
                            ),
                            items: DashboardPage.catlist.value.map((item) {
                              return DropdownMenuItem(
                                child: Text(
                                  item.itemName.toString(),
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "Sans"),
                                ),
                                value: item.itemName.toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                DashboardPage.selectedItemName = newVal;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                DashboardPage.selectedItemName = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  //TRANSACTION TYPE
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      width: double.infinity,
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            hint: Text(
                              'Sila Pilih Jenis Transaksi',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Sans"),
                            ),
                            items: txnOption.map((item) {
                              return DropdownMenuItem(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "Sans"),
                                ),
                                value: item.toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                DashboardPage.selectedTxnType = newVal;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                DashboardPage.selectedTxnType = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  //VENDOR LIST
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      width: double.infinity,
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            hint: Text(
                              'Sila Pilih Vendor',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Sans"),
                            ),
                            items: DashboardPage.vendorlist.value.map((item) {
                              return DropdownMenuItem(
                                child: Text(
                                  item.vendorName.toString(),
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "Sans"),
                                ),
                                value: item.vendorName,
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                DashboardPage.selectedVendor = newVal;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                DashboardPage.selectedVendor = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  //AMAUN
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(15, 0, 10, 0),
                        child: TextField(
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w300,
                              fontFamily: "Sans"),
                          controller: DashboardPage.amtCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              hintText: 'Amaun',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Sans")),
                        ),
                      ),
                    ),
                  ),
                  //PENERANGAN
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(15, 0, 10, 0),
                        child: TextField(
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w300,
                              fontFamily: "Sans"),
                          controller: DashboardPage.descCtrl,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              hintText: 'Penerangan',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Sans")),
                        ),
                      ),
                    ),
                  ),
                  //SUBMIT BUTTON
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        primary: Colors.white,
                      ),
                      onPressed: () async {
                        log('simpan rekod');
                        await submitData(context);
                      },
                      child: Text('Simpan Rekod'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
