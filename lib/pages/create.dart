import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:snote/model/api.dart';
import 'package:snote/pages/home.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Create extends StatefulWidget {
  final String title, content;
  final int color, id_note;
  const Create({Key key, this.title, this.content, this.color, this.id_note})
      : super(key: key);
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
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  String _url = '/notes_register';
  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    print(color.value);
  }

  initState() {
    setState(() {
      becomeUpdate();
    });
    super.initState();
  }

  becomeUpdate() {
    if (widget.title != null &&
        widget.content != null &&
        widget.color != null &&
        widget.id_note != null) {
      _titleController.text = widget.title;
      _contentController.text = widget.content;
      currentColor = Color(widget.color);
      _url = '/update_note/${widget.id_note}';
    }
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
                    controller: _titleController,
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
                    controller: _contentController,
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
            var data = {
              'title': title,
              'content': content,
              'background': pickerColor.value,
              'user_id': 1
            };
            var response = await model.sendData(data, _url);
            var action = json.decode(response.body);
            print(action);
            Navigator.pop(context);
          }
        },
        child: Icon(Icons.done_all),
        backgroundColor: Colors.purpleAccent,
      ),
    );
  }
}
