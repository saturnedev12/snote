import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:snote/model/api.dart';
import 'package:snote/pages/home.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Create extends StatefulWidget {
  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final _formKey = GlobalKey<FormState>();
  String title, content;
  Network model = new Network();
  // create some values
  Color pickerColor = Color(0xFFD79FF3);
  Color currentColor = Color(0xFFDFACF8);

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    print(color.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(3),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.text,
                    //textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'titre'),
                    validator: (value) {
                      title = value;
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: BlockPicker(
                      pickerColor: currentColor,
                      onColorChanged: changeColor,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 200,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Entrez vos notes'),
                    validator: (value) {
                      content = value;
                      return null;
                    },
                  ),
                ],
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Processing Data')));
            var data = {'title': title, 'content': content, 'user_id': 1};
            var response = await model.sendData(data, '/notes_register');
            var action = json.decode(response.body);
            print(action);
            Navigator.push(
                context, new MaterialPageRoute(builder: (context) => Home()));
          }
        },
        child: Icon(Icons.done_all),
        backgroundColor: Colors.purpleAccent,
      ),
    );
  }
}
