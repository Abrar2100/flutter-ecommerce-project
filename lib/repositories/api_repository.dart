import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/link.dart';

class ApiRepository {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    var response = await http.post(
      Uri.parse(Links.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    var response = await http.post(
      Uri.parse(Links.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> fetchCategories() async {
    var response = await http.get(Uri.parse(Links.categories));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> fetchProducts({String? search, int? categoryId, int page = 1}) async {
    var url = "${Links.products}?search=${search ?? ""}&category_id=${categoryId ?? ""}&page=$page";
    var response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> fetchProductDetails(String slug) async {
    var response = await http.get(Uri.parse(Links.productDetails(slug)));
    return jsonDecode(response.body);
  }
}
