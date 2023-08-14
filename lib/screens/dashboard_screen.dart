import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:login_signup/screens/all_transaction.dart';
import 'package:login_signup/screens/item_details.dart';
import 'package:login_signup/services/app_services.dart';
import 'package:login_signup/component/add_new_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/appconfig.dart';
import '../models/accountDto.dart';
import '../models/categoryListDto.dart';
import '../models/recordDto.dart';
import '../models/recordListDto.dart';
import 'package:http/http.dart' as http;

import '../models/vendorListDto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  static ValueNotifier<List<CategoryListDto>> catlist = ValueNotifier([]);
  static ValueNotifier<List<RecordListDto>> recordlist = ValueNotifier([]);
  static ValueNotifier<List<AccountDto>> accountdto = ValueNotifier([]);

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

  static AccountDto accDto = AccountDto();

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  RecordDto recordDto = RecordDto();

  late Future<AccountDto> acc;
  List txnStat = ['Perbelanjaan', 'Pendapatan'];
  List txnOption = ['FPX', 'CASH', 'LAIN-LAIN'];

  List<RecordListDto> test = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return NewRecordWidget();
              // return Container(
              //     height: 500,
              //     width: double.infinity,
              //     color: Colors.white,
              //     alignment: Alignment.center,
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Column(
              //         // mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           SizedBox(
              //             height: 10,
              //           ),
              //           Text('---- Borang Tambah Rekod ----',
              //               style: TextStyle(
              //                   color: Color.fromARGB(255, 0, 0, 0),
              //                   fontSize: 15.0,
              //                   fontWeight: FontWeight.bold,
              //                   fontFamily: "Sans")),
              //           SizedBox(
              //             height: 10,
              //           ),
              //           Container(
              //             width: double.infinity,
              //             child: DropdownButtonHideUnderline(
              //               child: ButtonTheme(
              //                 alignedDropdown: true,
              //                 child: DropdownButtonFormField(
              //                   hint: Text(
              //                     'Sila Pilih Status Transaksi',
              //                     style: TextStyle(
              //                         color: Color.fromARGB(255, 0, 0, 0),
              //                         fontSize: 13.0,
              //                         fontWeight: FontWeight.w300,
              //                         fontFamily: "Sans"),
              //                   ),
              //                   items: txnStat
              //                       .map((item) => DropdownMenuItem(
              //                             child: Text(
              //                               item,
              //                               style: TextStyle(
              //                                   color: Color.fromARGB(
              //                                       255, 0, 0, 0),
              //                                   fontSize: 13.0,
              //                                   fontWeight: FontWeight.w300,
              //                                   fontFamily: "Sans"),
              //                             ),
              //                             value: item,
              //                           ))
              //                       .toList(),
              //                   onChanged: (item) => setState(() {
              //                     DashboardPage.selectedTxnStat = item;
              //                   }),
              //                   onSaved: (value) {
              //                     setState(() {
              //                       DashboardPage.selectedTxnStat = value;
              //                     });
              //                   },
              //                 ),
              //               ),
              //             ),
              //           ),
              //           SizedBox(
              //             height: 10,
              //           ),
              //           Container(
              //             width: double.infinity,
              //             child: DropdownButtonHideUnderline(
              //               child: ButtonTheme(
              //                 alignedDropdown: true,
              //                 child: DropdownButtonFormField(
              //                   hint: Text(
              //                     'Sila Pilih Item',
              //                     style: TextStyle(
              //                         color: Color.fromARGB(255, 0, 0, 0),
              //                         fontSize: 13.0,
              //                         fontWeight: FontWeight.w300,
              //                         fontFamily: "Sans"),
              //                   ),
              //                   items: DashboardPage.catlist.value.map((item) {
              //                     return DropdownMenuItem(
              //                       child: Text(
              //                         item.itemName.toString(),
              //                         style: TextStyle(
              //                             color: Color.fromARGB(255, 0, 0, 0),
              //                             fontSize: 13.0,
              //                             fontWeight: FontWeight.w300,
              //                             fontFamily: "Sans"),
              //                       ),
              //                       value: item.itemName.toString(),
              //                     );
              //                   }).toList(),
              //                   onChanged: (newVal) {
              //                     setState(() {
              //                       DashboardPage.selectedItemName = newVal;
              //                     });
              //                   },
              //                   onSaved: (value) {
              //                     setState(() {
              //                       DashboardPage.selectedItemName = value;
              //                     });
              //                   },
              //                 ),
              //               ),
              //             ),
              //           ),
              //           SizedBox(
              //             height: 10,
              //           ),
              //           Container(
              //             width: double.infinity,
              //             child: DropdownButtonHideUnderline(
              //               child: ButtonTheme(
              //                 alignedDropdown: true,
              //                 child: DropdownButtonFormField(
              //                   hint: Text(
              //                     'Sila Pilih Jenis Transaksi',
              //                     style: TextStyle(
              //                         color: Color.fromARGB(255, 0, 0, 0),
              //                         fontSize: 13.0,
              //                         fontWeight: FontWeight.w300,
              //                         fontFamily: "Sans"),
              //                   ),
              //                   items: txnOption.map((item) {
              //                     return DropdownMenuItem(
              //                       child: Text(
              //                         item,
              //                         style: TextStyle(
              //                             color: Color.fromARGB(255, 0, 0, 0),
              //                             fontSize: 13.0,
              //                             fontWeight: FontWeight.w300,
              //                             fontFamily: "Sans"),
              //                       ),
              //                       value: item.toString(),
              //                     );
              //                   }).toList(),
              //                   onChanged: (newVal) {
              //                     setState(() {
              //                       DashboardPage.selectedTxnType = newVal;
              //                     });
              //                   },
              //                   onSaved: (value) {
              //                     setState(() {
              //                       DashboardPage.selectedTxnType = value;
              //                     });
              //                   },
              //                 ),
              //               ),
              //             ),
              //           ),
              //           SizedBox(
              //             height: 10,
              //           ),
              //           Container(
              //             width: double.infinity,
              //             child: DropdownButtonHideUnderline(
              //               child: ButtonTheme(
              //                 alignedDropdown: true,
              //                 child: DropdownButtonFormField(
              //                   hint: Text(
              //                     'Sila Pilih Vendor',
              //                     style: TextStyle(
              //                         color: Color.fromARGB(255, 0, 0, 0),
              //                         fontSize: 13.0,
              //                         fontWeight: FontWeight.w300,
              //                         fontFamily: "Sans"),
              //                   ),
              //                   items:
              //                       DashboardPage.vendorlist.value.map((item) {
              //                     return DropdownMenuItem(
              //                       child: Text(
              //                         item.vendorName.toString(),
              //                         style: TextStyle(
              //                             color: Color.fromARGB(255, 0, 0, 0),
              //                             fontSize: 13.0,
              //                             fontWeight: FontWeight.w300,
              //                             fontFamily: "Sans"),
              //                       ),
              //                       value: item.vendorName,
              //                     );
              //                   }).toList(),
              //                   onChanged: (newVal) {
              //                     setState(() {
              //                       DashboardPage.selectedVendor = newVal;
              //                     });
              //                   },
              //                   onSaved: (value) {
              //                     setState(() {
              //                       DashboardPage.selectedVendor = value;
              //                     });
              //                   },
              //                 ),
              //               ),
              //             ),
              //           ),
              //           SizedBox(
              //             height: 10,
              //           ),
              //           TextField(
              //             style: TextStyle(
              //                 color: Color.fromARGB(255, 0, 0, 0),
              //                 fontSize: 13.0,
              //                 fontWeight: FontWeight.w300,
              //                 fontFamily: "Sans"),
              //             controller: DashboardPage.amtCtrl,
              //             keyboardType: TextInputType.number,
              //             decoration: InputDecoration(
              //                 border: OutlineInputBorder(),
              //                 hintText: 'Amaun',
              //                 hintStyle: TextStyle(
              //                     color: Color.fromARGB(255, 0, 0, 0),
              //                     fontSize: 13.0,
              //                     fontWeight: FontWeight.w300,
              //                     fontFamily: "Sans")),
              //           ),
              //           SizedBox(
              //             height: 10,
              //           ),
              //           TextField(
              //             style: TextStyle(
              //                 color: Color.fromARGB(255, 0, 0, 0),
              //                 fontSize: 13.0,
              //                 fontWeight: FontWeight.w300,
              //                 fontFamily: "Sans"),
              //             controller: DashboardPage.descCtrl,
              //             decoration: InputDecoration(
              //                 border: OutlineInputBorder(),
              //                 hintText: 'Keterangan',
              //                 hintStyle: TextStyle(
              //                     color: Color.fromARGB(255, 0, 0, 0),
              //                     fontSize: 13.0,
              //                     fontWeight: FontWeight.w300,
              //                     fontFamily: "Sans")),
              //           ),
              //           SizedBox(
              //             height: 10,
              //           ),
              // TextButton(
              //   style: TextButton.styleFrom(
              //     backgroundColor: Colors.blue,
              //     primary: Colors.white,
              //   ),
              //   onPressed: () async {
              //     log('simpan rekod');
              //     await submitData(context);
              //   },
              //   child: Text('Simpan Rekod'),
              // )
              //         ],
              //       ),
              //     ));
            },
          ).then((value) => setState(() {}));
        },
        label: const Text(
          'Tambah',
          style: TextStyle(
            fontFamily: "Lemon",
            fontWeight: FontWeight.bold,
            fontSize: 13.0,
          ),
        ),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Halaman Utama",
          style: TextStyle(
              fontFamily: "Lemon",
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
              color: Colors.black87),
        ),
        elevation: 0.2,
      ),
      backgroundColor: Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            Row(
              children: [
                _balanceCard(
                  context,
                  Color.fromARGB(255, 34, 137, 246),
                  Color.fromARGB(255, 122, 184, 251),
                  "Baki Akaun :",
                  "\RM $bal",
                ),
                _walletCard(
                  context,
                  Color.fromARGB(255, 237, 233, 233),
                  Color.fromARGB(255, 255, 253, 253),
                  "Jumlah Permulaan :",
                  "\RM $strt",
                )
              ],
            ),
            SizedBox(
              height: 15.0,
            ),

            ///
            /// Header two card money (Spent and Earned)
            ///
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _card(context, Color(0xFF3FCE98), Color(0xFF76EE93),
                    "Pendapatan :", "\RM $inc", ""),
                _card(
                    context,
                    Color(0xFFF179A7),
                    Color.fromARGB(255, 250, 88, 96),
                    "Perbelanjaan :",
                    "\RM $exp",
                    ""),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),

            ///
            /// Get card today box
            ///
            _transaction(),
          ],
        ),
      ),
    );
  }

  //---------------------------------------widget section
  Widget _balanceCard(BuildContext ctx, Color _color1, Color _color2,
      String _title, String _value) {
    double _width = MediaQuery.of(ctx).size.width;
    return Padding(
      padding: const EdgeInsets.only(right: 7.0, left: 7.0),
      child: Container(
        alignment: Alignment.center,
        height: 100.0,
        width: _width / 2.19,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              _color1,
              _color2,
            ]),
            boxShadow: [
              BoxShadow(
                  offset: Offset(6, 7),
                  color: _color1.withOpacity(0.45),
                  blurRadius: 5.0,
                  spreadRadius: 1.0)
            ],
            borderRadius: BorderRadius.all(Radius.circular(7.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  _title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w300,
                      fontFamily: "Sans"),
                ),
              ],
            ),
            SizedBox(
              height: 2.0,
            ),
            Text(
              _value,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16.0,
                  fontFamily: "Popins",
                  letterSpacing: 1.4),
            ),
            SizedBox(
              height: 5.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _walletCard(BuildContext ctx, Color _color1, Color _color2,
      String _title, String _value) {
    double _width = MediaQuery.of(ctx).size.width;
    return GestureDetector(
      onTap: () {
        log('edit wallet bal');
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 7.0, left: 7.0),
        child: Container(
          alignment: Alignment.center,
          height: 100.0,
          width: _width / 2.19,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                _color1,
                _color2,
              ]),
              boxShadow: [
                BoxShadow(
                    offset: Offset(6, 7),
                    color: _color1.withOpacity(0.45),
                    blurRadius: 5.0,
                    spreadRadius: 1.0)
              ],
              borderRadius: BorderRadius.all(Radius.circular(7.0))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _title,
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 13.0,
                        fontWeight: FontWeight.w300,
                        fontFamily: "Sans"),
                  ),
                ],
              ),
              SizedBox(
                height: 2.0,
              ),
              Text(
                _value,
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.w800,
                    fontSize: 16.0,
                    fontFamily: "Popins",
                    letterSpacing: 1.4),
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// widget for card header
  ///
  Widget _card(BuildContext ctx, Color _color1, Color _color2, String _title,
      String _value, String _ket) {
    double _width = MediaQuery.of(ctx).size.width;
    return Padding(
      padding: const EdgeInsets.only(right: 7.0, left: 7.0),
      child: Container(
        height: 100.0,
        width: _width / 2.19,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              _color1,
              _color2,
            ]),
            boxShadow: [
              BoxShadow(
                  offset: Offset(6, 7),
                  color: _color1.withOpacity(0.45),
                  blurRadius: 5.0,
                  spreadRadius: 1.0)
            ],
            borderRadius: BorderRadius.all(Radius.circular(7.0))),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w300,
                        fontFamily: "Sans"),
                  ),
                ],
              ),
              SizedBox(
                height: 2.0,
              ),
              Text(
                _value,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16.0,
                    fontFamily: "Popins",
                    letterSpacing: 1.4),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                _ket,
                style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w300,
                    fontSize: 12.0),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// Box today transaction
  ///
  Widget _transaction() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15.0,
                  spreadRadius: 0.0)
            ]),
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Rekod Terkini :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Sans",
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.blueGrey.shade100,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllTransactionScreen()),
                      );
                    },
                    child: Text(
                      "Lihat Semua",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w300,
                        fontFamily: "Sans",
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 350,
              child: ListView.builder(
                  itemCount: DashboardPage.recordlist.value.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Slidable(
                      endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () {}),
                          children: [
                            SlidableAction(
                              onPressed: ((context) async {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ItemDetailsPage(
                                      id: DashboardPage
                                          .recordlist.value[index].id!
                                          .toInt()),
                                ));
                              }),
                              backgroundColor:
                                  Color.fromARGB(255, 63, 159, 248),
                              foregroundColor: Colors.white,
                              icon: Icons.panorama_fish_eye_sharp,
                              label: 'Lihat',
                            ),
                            SlidableAction(
                              onPressed: (context) async {
                                _confirmDelete(DashboardPage
                                    .recordlist.value[index].id!
                                    .toInt());
                              },
                              backgroundColor: Color.fromARGB(255, 250, 88, 96),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Hapus',
                            ),
                          ]),
                      child: ListTile(
                        tileColor: Colors.white,
                        title: Text(
                            DashboardPage.recordlist.value[index].itemName
                                .toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.0,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Sans")),
                        subtitle: Text(
                          '${DashboardPage.recordlist.value[index].createdAt.toString()} \n ${DashboardPage.recordlist.value[index].itemType.toString()}',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Sans"),
                        ),
                        trailing: Text(
                            DashboardPage.recordlist.value[index].itemAmt
                                .toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w300,
                                fontFamily: "Sans")),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class FabExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FloatingActionButton Sample'),
      ),
      body: const Center(
        child: Text('Press the button with a label below!'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        label: const Text('Approve'),
        icon: const Icon(Icons.thumb_up),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
