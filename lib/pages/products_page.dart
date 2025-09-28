import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/link.dart';

class ProductsPage extends StatefulWidget {
  final int? categoryId; // نقدر نمرر category_id اختيارياً

  ProductsPage({this.categoryId});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List products = [];
  bool loading = true;
  String searchQuery = "";

  Future<void> fetchProducts() async {
    try {
      String url = "${Links.products}?search=$searchQuery";
      if (widget.categoryId != null) {
        url += "&category_id=${widget.categoryId}";
      }

      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          products = data['data']['data']; // pagination → data.data
          loading = false;
        });
      } else {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load products")),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void onSearch(String query) {
    setState(() {
      searchQuery = query;
      loading = true;
    });
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Products", style: TextStyle(color: Colors.white)),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    onSubmitted: onSearch,
                    decoration: InputDecoration(
                      hintText: "Search products...",
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
                  child: ListView.builder(
                    
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];
                      return Card(
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: ListTile(
                          leading: product['image'] != null
                              ? Image.network(
                                  "http://127.0.0.1:8000/storage/${product['image']}",
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.image, color: Colors.blue),
                          title: Text(product['name'],
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              "${product['price']} \$ • Qty: ${product['quantity']}"),
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