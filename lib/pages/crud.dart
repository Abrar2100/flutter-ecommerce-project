import 'dart:convert';
import 'package:http/http.dart' as http;

class Crud {
  postData(String linkurl, Map data) async {
    try {
      var response = await http.post(
        Uri.parse(linkurl),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responesbody = jsonDecode(response.body);

        print(responesbody);
        return responesbody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch $e");
    }
  }

  getData(String linkurl) async {
    try {
      var response = await http.get(Uri.parse(linkurl));
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responesbody = jsonDecode(response.body);

        print(responesbody);
        return responesbody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch $e");
    }
  }

}
