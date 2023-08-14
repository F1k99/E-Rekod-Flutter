import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../config/appconfig.dart';
import '../models/categoryListDto.dart';
import '../services/app_services.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({Key? key}) : super(key: key);

  static ValueNotifier<List<CategoryListDto>> catlist = ValueNotifier([]);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  var id = 0;

  init() async {
    await getVendorList();

    getVendorList().then((response) {
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
            Text('Adakah anda pasti untuk memadam kategori ini?',
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
              deleteVendorCategory(id, context);
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Senarai Kategori",
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
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: ListView.builder(
                        itemCount: CategoryListScreen.catlist.value.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Slidable(
                              endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  dismissible:
                                      DismissiblePane(onDismissed: () {}),
                                  children: [
                                    // SlidableAction(
                                    //   onPressed: _edit(),
                                    //   backgroundColor:
                                    //       Color.fromARGB(255, 63, 159, 248),
                                    //   foregroundColor: Colors.white,
                                    //   icon: Icons.edit,
                                    //   label: 'Edit',
                                    // ),
                                    SlidableAction(
                                      onPressed: (context) async {
                                        _confirmDelete(CategoryListScreen
                                            .catlist.value[index].id!
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
                                    CategoryListScreen
                                        .catlist.value[index].itemName
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: "Sans")),
                                subtitle: Text(
                                  CategoryListScreen
                                      .catlist.value[index].createdAt
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Sans"),
                                ),
                                trailing: Text(
                                  CategoryListScreen
                                      .catlist.value[index].itemStat
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Sans"),
                                ),
                              ));
                        }),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
