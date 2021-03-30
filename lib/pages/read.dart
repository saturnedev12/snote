import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Read extends StatelessWidget {
  @override
  final String title, content;

  const Read({Key key, this.title, this.content}) : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$title"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Markdown(data: content),
    );
  }
}
