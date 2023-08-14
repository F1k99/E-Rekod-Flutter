import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_signup/screens/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/appconfig.dart';
import '../models/accountDto.dart';
import '../models/categoryListDto.dart';
import '../models/profileDto.dart';
import '../models/recordDto.dart';
import '../models/recordListDto.dart';
import 'package:http/http.dart' as http;

import '../models/userListDto.dart';
import '../screens/all_transaction.dart';
import '../screens/categorylist_screen.dart';
import '../screens/bottom_nav_bar.dart';
import '../screens/item_details.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/setting_screen.dart';
import '../screens/userlist_screen.dart';

final storage = const FlutterSecureStorage();

// auth API
login(context) async {
  ('login clicked');

  try {
    String uri = "${AppConfig.apiEndPoint}/login";
    var res = await http.post(Uri.parse(uri), body: {
      "email": LoginScreen.emailController.text,
      "password": LoginScreen.passwordController.text
    });

    var response = jsonDecode(res.body);

    if (res.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", true);
      var token = response['success']['token'];
      // var roleid = response['success']['role'];
      // log(token.toString());
      // log(roleid.toString());

      // Create storage
      final storage = new FlutterSecureStorage();
      // Write value
      await storage.write(key: 'jwt', value: token);

      log("Login Success");
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationScreen(),
        ),
      );
    } else {
      log("Login Failed");
    }
  } catch (e) {
    print(e);
  }
}

register(context) async {
  log('register clicked');

  try {
    String uri = "${AppConfig.apiEndPoint}/register";
    var res = await http.post(
      Uri.parse(uri),
      body: {
        "name": RegisterScreen.nameController.text,
        "email": RegisterScreen.emailController.text,
        "password": RegisterScreen.passwordController.text,
        "c_password": RegisterScreen.passwordController.text,
      },
    );

    var response = jsonDecode(res.body);
    log(response.toString());
    if (res.statusCode == 200) {
      log("Register Success");
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationScreen(),
        ),
      );
    } else {
      log("Register Failed");
    }
  } catch (e) {
    print(e);
  }
}

//profile API
Future<ProfileDto> fetchProfile() async {
  var value = await storage.read(key: 'jwt');

  final response = await http.post(
    Uri.parse('${AppConfig.apiEndPoint}/profile'),
    // Send authorization headers to the backend.
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $value',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    SettingPage.profileDto =
        ProfileDto.fromJson(jsonDecode(response.body)['result']);

    return ProfileDto.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load profile');
  }
}

//record API

callRecordDataById(id) async {
  log(id.toString());
  final http.Response response =
      await http.get(Uri.parse("${AppConfig.apiEndPoint}/record/$id"));
  log(response.statusCode.toString());
  var jsonResponse = jsonDecode(response.body)['result'];
  log(jsonResponse.toString());

  if (response.statusCode == 200) {
    ItemDetailsPage.recordDto =
        RecordDto.fromJson(jsonDecode(response.body)['result']);

    return RecordDto.fromJson(jsonDecode(response.body));
  } else {
    throw ('Error Edit');
  }
}

Future<List<RecordListDto>> getRecordList() async {
  var res =
      await http.get(Uri.parse("${AppConfig.apiEndPoint}/api/recordlist"));

  if (res.statusCode == 200) {
    List<RecordListDto> r = json
        .decode(res.body)['result']!
        .map<RecordListDto>((x) => RecordListDto.fromJson(x))
        .toList();

    return AllTransactionScreen.recordlist.value = r;
  } else {
    throw ('Cant Get List');
  }
}

deleteRecord(id, context) async {
  log(id.toString());
  final http.Response response =
      await http.delete(Uri.parse("${AppConfig.apiEndPoint}/deleterecord/$id"));
  Navigator.pop(context);
  log(response.statusCode.toString());
  if (response.statusCode == 200) {
    Fluttertoast.showToast(
        msg: "Rekod Berjaya Dipadam",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 46, 161, 0),
        textColor: Colors.white,
        fontSize: 13.0);
    return response;
  } else {
    Fluttertoast.showToast(
        msg: "Rekod Tidak Berjaya Dipadam",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 161, 0, 0),
        textColor: Colors.white,
        fontSize: 13.0);
  }
}

//vendor API

Future<List<CategoryListDto>> getVendorList() async {
  var res = await http.get(Uri.parse("${AppConfig.apiEndPoint}/categorylist"));

  if (res.statusCode == 200) {
    List<CategoryListDto> r = json
        .decode(res.body)['result']!
        .map<CategoryListDto>((x) => CategoryListDto.fromJson(x))
        .toList();

    return CategoryListScreen.catlist.value = r;
  } else {
    throw ('Cant Get List');
  }
}

deleteVendorCategory(id, context) async {
  log(id.toString());
  final http.Response response = await http
      .delete(Uri.parse("${AppConfig.apiEndPoint}/deletecategory/$id"));
  Navigator.pop(context);
  log(response.statusCode.toString());
  if (response.statusCode == 200) {
    Fluttertoast.showToast(
        msg: "Kategori Berjaya Dipadam",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 46, 161, 0),
        textColor: Colors.white,
        fontSize: 13.0);
    return response;
  } else {
    Fluttertoast.showToast(
        msg: "Ralat, Kategori Tidak Berjaya Dipadam",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 161, 0, 0),
        textColor: Colors.white,
        fontSize: 13.0);
  }
}

//dashboard API

Future<List<CategoryListDto>> getCategoryList() async {
  var res = await http.get(Uri.parse("${AppConfig.apiEndPoint}/categorylist"));

  if (res.statusCode == 200) {
    List<CategoryListDto> r = json
        .decode(res.body)['result']!
        .map<CategoryListDto>((x) => CategoryListDto.fromJson(x))
        .toList();

    return DashboardPage.catlist.value = r;
  } else {
    throw ('Cant Get List');
  }
}

submitData(context) async {
  var res = await http.post(Uri.parse("${AppConfig.apiEndPoint}/record"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'item_name': DashboardPage.selectedItemName,
        'item_type': DashboardPage.selectedTxnType,
        'item_stat': DashboardPage.selectedTxnStat,
        'vendor_name': DashboardPage.selectedVendor,
        'item_amt': DashboardPage.amtCtrl.text,
        'desc': DashboardPage.descCtrl.text,
        // 'created_at': _dateCtrl.text,
      }));
  log(res.body.toString());
  if (res.statusCode == 200) {
    log('message');
    Navigator.pop(context);
    Fluttertoast.showToast(
        msg: "Rekod Berjaya Ditambah",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 46, 161, 0),
        textColor: Colors.white,
        fontSize: 13.0);
  } else {
    Fluttertoast.showToast(
        msg: "Ralat, Cuba Lagi Sekali",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 161, 11, 0),
        textColor: Colors.white,
        fontSize: 13.0);
  }
}

Future<List<AccountDto>> getAccDetails() async {
  var res =
      await http.get(Uri.parse("${AppConfig.apiEndPoint}/accountdetails"));

  if (res.statusCode == 200) {
    List<AccountDto> r = json
        .decode(res.body)['result']!
        .map<AccountDto>((x) => AccountDto.fromJson(x))
        .toList();

    return DashboardPage.accountdto.value = r;
  } else {
    throw ('Cant Get Acc details');
  }
}

Future<AccountDto> fetchAcc() async {
  final response = await http.get(
    Uri.parse('${AppConfig.apiEndPoint}/accountdetails'),
  );

  log(response.toString());

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    DashboardPage.accDto = AccountDto.fromJson(jsonDecode(response.body));

    return AccountDto.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load acc');
  }
}

// Item API

//user management API
Future<List<UserListDto>> getUserList() async {
  var res = await http.get(Uri.parse("${AppConfig.apiEndPoint}/userlist"));

  if (res.statusCode == 200) {
    List<UserListDto> r = json
        .decode(res.body)['result']!
        .map<UserListDto>((x) => UserListDto.fromJson(x))
        .toList();

    return UserListScreen.userlist.value = r;
  } else {
    throw ('Cant Get List');
  }
}

deleteUser(id, context) async {
  log(id.toString());
  final http.Response response =
      await http.delete(Uri.parse("${AppConfig.apiEndPoint}/userdelete/$id"));
  Navigator.pop(context);
  log(response.statusCode.toString());
  if (response.statusCode == 200) {
    Fluttertoast.showToast(
        msg: "Rekod Berjaya Dipadam",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 46, 161, 0),
        textColor: Colors.white,
        fontSize: 13.0);
    return response;
  } else {
    Fluttertoast.showToast(
        msg: "Rekod Tidak Berjaya Dipadam",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 161, 0, 0),
        textColor: Colors.white,
        fontSize: 13.0);
  }
}
