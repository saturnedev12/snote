import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snote/model/api.dart';
import 'package:snote/pages/home.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:snote/pages/login.dart';
import 'package:snote/pages/fonction.dart';

Future resize() async {
  await DesktopWindow.setMaxWindowSize(Size(400, 800));
  await DesktopWindow.setMinWindowSize(Size(100, 300));
}

void main() {
  forpc();
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Network model = new Network();
  bool isAuth = false;
  initState() {
    print('main page isAuth=$isAuth');
    forpc();
    _checkAuth();
    super.initState();
  }

  _checkAuth() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //if there is not token isAuth stay false
    var token = localStorage.getString('TOKEN');
    var user = localStorage.getString("USER");
    print(token);

    if (token != null || token.isNotEmpty || user.isNotEmpty) {
      isAuth = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth == true) {
      child = Home();
    } else {
      child = Login();
    }
    return child;
  }
}
