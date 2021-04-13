import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'http://snote-api-server.herokuapp.com/api';
  var token;
  _headers() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('TOKEN'));
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    print("l'url demandé est: $fullUrl");
    _getToken();
    var response = await http.get(fullUrl);
    //print(response.body);
    return response.body;
  }

  sendData(data, apiUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var fullUrl = _url + apiUrl;
    print("l'url post est: $fullUrl");
    var response = await http.post(
      fullUrl,
      body: jsonEncode(data),
      headers: _headers(),
    );
    print(response.body);
    var action = json.decode(response.body);
    if (action['success']) {
      localStorage.setString('USER', json.encode(action['user']));
      localStorage.setString('TOKEN', json.encode(action['token']));

      return response.body;
    } else {
      return action['message'];
    }
  }
}
