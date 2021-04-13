import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snote/pages/read.dart';
import 'package:snote/model/api.dart';
import 'dart:convert';
import 'package:snote/pages/create.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:desktop_window/desktop_window.dart';
import 'dart:io';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Network model = new Network();
  List myNotes = [];
  String name;
  int nbnotes = 0;
  //recuperation des donees
  _getUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String res = localStorage.getString('NOTES');

    if (res != null)
      myNotes = await jsonDecode(res);
    else
      myNotes = [];

    nbnotes = myNotes.length;
    // name = jsonDecode(localStorage.getString('NAME'));
    print("page home");
    //return myNotes;
  }

  _getDataInside() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    print(localStorage.getString('TOKEN'));
    var me = jsonDecode(localStorage.getString('USER'));
    print(me);
    var mid = me['id'];
    String response = await model.getData('/notes/$mid');
    if (localStorage.getString('NOTES') != response) {
      localStorage.setString('NOTES', response);
    }
    setState(() {
      _getUserData();
    });
  }

  @override
  void initState() {
    _getUserData();
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      DesktopWindow.setWindowSize(Size(400, 600));
      DesktopWindow.setMaxWindowSize(Size(700, 700));
      //DesktopWindow.setMinWindowSize(Size(300, 300));
    }
    new Timer.periodic(Duration(seconds: 1), (Timer t) => _getDataInside());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Mes notes",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.purpleAccent),
                  child: Center(
                    child: Text(
                      "$nbnotes",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 10),
                    ),
                  ),
                )
              ],
            ),
            Container(
                width: 190,
                height: 34,
                //color: Colors.red,
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "rechercher une note",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ))
          ],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Grilles(datas: myNotes),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, new MaterialPageRoute(builder: (context) => Create()));
        },
      ),
    );
  }
}

class Grilles extends StatelessWidget {
  final List<dynamic> datas;

  Grilles({Key key, this.datas}) : super(key: key);
  final buttonKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(1),
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 3,
        children: <Widget>[
          for (var item in datas)
            InkWell(
              child: Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTapUp: (TapUpDetails details) {
                            showPopup(details.globalPosition, item, context);
                            print(item['id']);
                          },
                          child: Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Flexible(
                      child: Text(
                        item['title'],
                        style: TextStyle(fontSize: 15, fontFamily: 'Chilanka'),
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Color(item['background']),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onTap: () {
                print('you touch me ?');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Read(
                              title: item['title'],
                              content: item['content'],
                              background: item['background'],
                            )));
              },
            )
        ],
      ),
    );
  }
}

//popup for more operation
void showPopup(Offset offset, dynamic datas, BuildContext context) {
  print(datas['title']);
  PopupMenu menu = PopupMenu(
      backgroundColor: Color(datas['background'] + 30),
      // lineColor: Colors.tealAccent,
      maxColumn: 3,
      items: [
        MenuItem(
            title: 'supprimer', image: Icon(Icons.delete, color: Colors.white)),
        MenuItem(
            title: 'modifier', image: Icon(Icons.create, color: Colors.white)),
        MenuItem(
            title: 'partager',
            image: Icon(
              Icons.share,
              color: Colors.white,
            )),
      ],
      onClickMenu: (MenuItemProvider item) {
        Network modele = new Network();
        print('Click menu -> ${item.menuTitle}');
        if (item.menuTitle == 'supprimer') {
          print('tu as cliqué sur suprimer');
          var response = modele.getData("/delete_note/${datas['id']}");
          print(jsonEncode(response));
          Navigator.push(
              context, new MaterialPageRoute(builder: (context) => Home()));
        }
        if (item.menuTitle == 'modifier') {
          print("modification en cours de $datas");
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => Create(
                        title: datas['title'],
                        content: datas['content'],
                        color: datas['background'],
                        id_note: datas['id'],
                      )));
        }
      },
      stateChanged: stateChanged,
      onDismiss: onDismiss);
  menu.show(rect: Rect.fromPoints(offset, offset));
}

void stateChanged(bool isShow) {
  print('menu is ${isShow ? 'showing' : 'closed'}');
}

void onDismiss() {
  print('Menu is dismiss');
}

/*void onClickMenu(MenuItemProvider item) {
  Network model = new Network();
  print('Click menu -> ${item.menuTitle}');
  if (item.menuTitle == 'supprimer') {
    print('tu as cliqué sur suprimer');
    model.getData('/api/notes/${}');
  }
  FutureBuilder(
        future: model.getData('/notes/1'),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          List sn = snapshot.data;
          nbnotes = sn.length;
          return snapshot.hasData
              ? Grilles(datas: snapshot.data)
              : Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 300,
                    ),
                    CircularProgressIndicator(),
                  ],
                );
        },
      ),
      import 'dart:async';

main() {
  new Timer.periodic(Duration(seconds: 2), (Timer t) => print('hi!'));
}

}*/
