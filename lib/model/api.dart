import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'http://localhost:8000/api';
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
    _getToken();
    var response = await http.get(fullUrl);
    return json.decode(response.body);
  }

  sendData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(
      fullUrl,
      body: jsonEncode(data),
      headers: _headers(),
    );
  }
}
