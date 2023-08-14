import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_signup/screens/item_details.dart';

import '../config/appconfig.dart';
import '../models/recordListDto.dart';
import 'package:http/http.dart' as http;

import '../services/app_services.dart';

class AllTransactionScreen extends StatefulWidget {
  const AllTransactionScreen({Key? key}) : super(key: key);

  static ValueNotifier<List<RecordListDto>> recordlist = ValueNotifier([]);

  @override
  State<AllTransactionScreen> createState() => _AllTransactionScreenState();
}

class _AllTransactionScreenState extends State<AllTransactionScreen> {
  var id = 0;

  init() async {
    await getRecordList();

    getRecordList().then((response) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    init();
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Senarai Transaksi",
            style: TextStyle(
                fontFamily: "Lemon",
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                color: Colors.black87),
          ),
          elevation: 0.2,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        itemCount: AllTransactionScreen.recordlist.value.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Slidable(
                            endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                dismissible:
                                    DismissiblePane(onDismissed: () {}),
                                children: [
                                  SlidableAction(
                                    onPressed: ((context) async {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => ItemDetailsPage(
                                            id: AllTransactionScreen
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
                                      _confirmDelete(AllTransactionScreen
                                          .recordlist.value[index].id!
                                          .toInt());
                                    },
                                    backgroundColor:
                                        Color.fromARGB(255, 250, 88, 96),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Hapus',
                                  ),
                                ]),
                            child: ListTile(
                              tileColor: Colors.white,
                              title: Text(
                                  AllTransactionScreen
                                      .recordlist.value[index].itemName
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "Sans")),
                              subtitle: Text(
                                AllTransactionScreen
                                    .recordlist.value[index].itemType
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Sans"),
                              ),
                              trailing: Text(
                                  AllTransactionScreen
                                      .recordlist.value[index].itemAmt
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
            )
          ],
        ));
  }
}
