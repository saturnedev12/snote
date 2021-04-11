import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snote/model/api.dart';
import 'package:snote/pages/home.dart';
import 'package:desktop_window/desktop_window.dart';

Future resize() async {
  await DesktopWindow.setMaxWindowSize(Size(400, 800));
  await DesktopWindow.setMinWindowSize(Size(100, 300));
}

void main() {
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
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      DesktopWindow.setWindowSize(Size(400, 600));
      DesktopWindow.setMaxWindowSize(Size(700, 700));
      //DesktopWindow.setMinWindowSize(Size(300, 300));
    }
    _checkAuth();
    super.initState();
  }

  _checkAuth() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token; // = localStorage.getString('token');
    if (token != null) {
      isAuth = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      child = Home();
    } else {
      child = Home();
    }
    return child;
  }
}
