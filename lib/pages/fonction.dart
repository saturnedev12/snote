import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:snote/model/api.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:snote/pages/create.dart';
import 'package:desktop_window/desktop_window.dart';
forpc(){
   if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      DesktopWindow.setFullScreen(false);
      DesktopWindow.setWindowSize(Size(600, 600));
      DesktopWindow.setMaxWindowSize(Size(900, 900));
      //DesktopWindow.setMinWindowSize(Size(300, 300));
    }
}
//verifie connexion
Future<bool> verifiConnect(BuildContext context) async{
  try{
    final result = await InternetAddress.lookup('google.com');
    if(result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      return true;
    }
    else{
      showAlertDialog(context);
      return false;
    }
  }on SocketException catch(_){
    print('not connected');
    showAlertDialog(context);
    return false;
  }
}
showAlertDialog(BuildContext context){
  //button
  Widget okButton = FlatButton(
    child: Text('ok'),
    onPressed: (){
      Navigator.of(context).pop();

    },
  );
  //alert dialog
  AlertDialog alert = AlertDialog(
    title: Text('Aucune Connexion'),
    content: Text("connectez vous a internet s'il vous plait"),
    actions: [
      okButton,
    ],
  );
  //show dialogue
  showDialog(context: context, builder: (BuildContext builder){
    return alert;
  });
}
//get all nots
Future<List> getMyNotes(int id) async{
  Network net = new Network();

  print('Future in charge');
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var res = await net.getData('/notes/1');
  if(res != null){
    return jsonDecode(res);
  }else{
    return [];
  }

  //return myNotes;
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
        Navigator.of(context).pop();


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
    onDismiss: onDismiss,


  );

  menu.show(rect: Rect.fromPoints(offset, offset));

}

void stateChanged(bool isShow) {

  print('menu is ${isShow ? 'showing' : 'closed'}');
}

void onDismiss() {
  print('Menu is dismiss');

}




