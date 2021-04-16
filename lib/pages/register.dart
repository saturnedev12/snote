import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:snote/model/api.dart';
//import 'dart:convert';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:snote/main.dart';

import 'package:snote/pages/home.dart';
import 'fonction.dart';
import 'package:snote/main.dart';
//import 'dart:io' show Platform;
//import 'package:device_info/device_info.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool passwordVisible = true, isloading = false;
  var name, email, password, device_name;
  Network model = new Network();
  Map<String, dynamic> data;
  final formKey = GlobalKey<FormState>();
  chargement(
      var mformKey, BuildContext mcontext, String memail, String mpassword) {
    print("en charge");
    return FutureBuilder(
      future: model.sendData(data, '/register'),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return snapshot.hasData
            ?Home()
            : Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.purpleAccent,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
    /*Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.purpleAccent,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );*/
  }
  initSate(){
    verifiConnect(context);
    super.initState();
  }
  Widget build(BuildContext context) {
    Widget page;
    if (isloading) {
      page = chargement(formKey, context, email, password);
    } else {
      page = Scaffold(
        body: Container(
          padding: EdgeInsets.all(30),
          color: Colors.blueGrey,
          child: Center(
            child: Container(
              width: double.infinity,
              height: 250,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.deepOrange[200],
                  borderRadius: BorderRadius.circular(20)),
              child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'name'),
                        validator: (value) {
                          name = value;
                          return null;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'email'),
                        validator: (value) {
                          email = value;
                          return null;
                        },
                      ),
                      TextFormField(
                        obscureText: passwordVisible,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'password'),
                        validator: (value) {
                          password = value;
                          return null;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async{
                          setState(() {
                            if (formKey.currentState.validate()) {
                              data = {
                                'name': name,
                                'email': email,
                                'password': password,
                                'device_name': "samsung"
                              };
                              print('essaie envoyer $data');
                            }
                            isloading = true;
                          });
                        },
                        child: Text('register'),
                      ),
                      // ignore: deprecated_member_use

                    ],
                  )),
            ),
          ),
        ),
      );
    }
    return page;
  }
}

Future<String> sendInfo(
    var formKey, BuildContext context,String name, String email, String password) async {
  print("||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
  Network model = new Network();
  if (formKey.currentState.validate()) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Processing Data')));
    var data = {'name':name, 'email': email, 'password': password, 'device_name': "samsung"};
    var response = await model.sendData(data, '/register');

    var action = json.decode(response.body);
    print(action);
    if (action['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('USER', json.encode(action['user']));
      localStorage.setString('TOKEN', json.encode(action['token']));
      return response.body;
      //Navigator.push(context, new MaterialPageRoute(builder: (context) => MyApp()));
    } else {
      print(action['message']);
    }
  } else {
    //Navigator.push(context, new MaterialPageRoute(builder: (context) => MyApp()));

    return 'no';
  }
}





/*
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool passwordVisible = false;
  String name, email, password;
  Network model = new Network();
  @override
  final _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        color: Colors.purpleAccent,
        child: Center(
          child: Container(
            width: double.infinity,
            height: 300,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.deepOrange[200],
                borderRadius: BorderRadius.circular(20)),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'name'),
                      validator: (value) {
                        name = value;
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'email'),
                      validator: (value) {
                        email = value;
                        return null;
                      },
                    ),
                    TextFormField(
                      obscureText: passwordVisible,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'password'),
                      validator: (value) {
                        password = value;
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Processing Data')));
                          Map data = {
                            'name': name,
                            'email': email,
                            'password': password,
                            'device_name': "samsung"
                          };
                          print('my data is : $data');
                          var response =
                              await model.sendData(data, '/register');
                          var action = json.decode(response.body);
                          print(action);
                          //quand tout est bon
                          if (action['success']) {
                            print(action['user']);
                            SharedPreferences localStorage =
                                await SharedPreferences.getInstance();
                            localStorage.setString(
                                'USER', json.encode(action['user']));
                            localStorage.setString(
                                'TOKEN', json.encode(action['token']));

                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => MyApp()),
                            );
                          } else {
                            print(action["message"]);
                          }
                        }
                      },
                      child: Text('register'),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
*/