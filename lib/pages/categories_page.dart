import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/link.dart';

class CategoriesPage extends StatefulWidget {
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List categories = [];
  List filteredCategories = [];
  bool loading = true;

  Future<void> fetchCategories() async {
    try {
      var response = await http.get(Uri.parse(Links.categories));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          categories = data['data'];
          filteredCategories = categories; // نسخة للبحث
          loading = false;
        });
      } else {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load categories")),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void filterCategories(String query) {
    List results = [];
    if (query.isEmpty) {
      results = categories;
    } else {
      results = categories
          .where((cat) =>
              cat['name'].toLowerCase().contains(query.toLowerCase()) ||
              cat['slug'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredCategories = results;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Categories", style: TextStyle(color: Colors.white)),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : Column(
              children: [
                // 🔎 شريط البحث
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    onChanged: (value) => filterCategories(value),
                    decoration: InputDecoration(
                      hintText: "Search categories...",
                      prefixIcon: Icon(Icons.search, color: Colors.blue),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredCategories.isEmpty
                      ? Center(
                          child: Text(
                            "No categories found",
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[700]),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredCategories.length,
                          itemBuilder: (context, index) {
                            var category = filteredCategories[index];
                            return Card(
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: Text(
                                    category['name'][0].toUpperCase(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(category['name'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text("Slug: ${category['slug']}"),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}