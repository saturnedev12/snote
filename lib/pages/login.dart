import 'package:flutter/material.dart';
import 'package:snote/model/api.dart';
import 'dart:convert';
import 'package:snote/pages/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snote/pages/home.dart';

//import 'dart:io' show Platform;
//import 'package:device_info/device_info.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool passwordVisible = true;
  var email, password, device_name;
  Network model = new Network();
  @override
  final _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        color: Colors.blue,
        child: Center(
          child: Container(
            width: double.infinity,
            height: 200,
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
                          var data = {
                            'email': email,
                            'password': password,
                            'device_name': "samsung"
                          };
                          var response = await model.sendData(data, '/login');

                          var action = json.decode(response.body);
                          print(action);
                          if (action['success']) {
                            SharedPreferences localStorage =
                                await SharedPreferences.getInstance();
                            localStorage.setString(
                                'NAME', json.encode(action['user']));
                            localStorage.setString(
                                'EMAIL', json.encode(action['email']));
                            localStorage.setString(
                                'TOKEN', json.encode(action['token']));
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => Home()));
                          }
                          print("hello");
                        }
                      },
                      child: Text('login'),
                    ),
                    FlatButton(
                        child: Text("register"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()));
                        })
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
