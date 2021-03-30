import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:snote/model/api.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snote/pages/home.dart';

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
        color: Colors.blue,
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
                                  builder: (context) => Home()),
                            );
                          }
                          print("hello");
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
