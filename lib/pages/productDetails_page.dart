import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/link.dart';
import '../database/cart_db.dart'; // ✅ استدعاء قاعدة بيانات السلة

class ProductDetailsPage extends StatefulWidget {
  final String slug;

  ProductDetailsPage({required this.slug});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Map? product;
  bool loading = true;

  Future<void> fetchProduct() async {
    try {
      var response =
          await http.get(Uri.parse(Links.productDetails(widget.slug)));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          product = data['data'];
          loading = false;
        });
      } else {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load product")),
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
    fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Product Details", style: TextStyle(color: Colors.white)),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : product == null
              ? Center(child: Text("Product not found"))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // صورة المنتج
                        product!['image'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  "http://127.0.0.1:8000/storage/${product!['image']}",
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                height: 200,
                                color: Colors.grey[300],
                                child: Icon(Icons.image,
                                    size: 80, color: Colors.blue),
                              ),
                        SizedBox(height: 20),
                        // اسم المنتج
                        Text(
                          product!['name'],
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        // السعر والكمية
                        Text(
                          "Price: ${product!['price']} \$",
                          style: TextStyle(
                              fontSize: 18, color: Colors.blue[800]),
                        ),
                        Text(
                          "Quantity: ${product!['quantity']}",
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 20),
                        // الوصف
                        Text(
                          product!['description'] ??
                              "No description available",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        // الصنف
                        if (product!['category'] != null)
                          Chip(
                            label: Text(
                                "Category: ${product!['category']['name']}"),
                            backgroundColor: Colors.blue[100],
                          ),
                        SizedBox(height: 30),

                        // ✅ زر الإضافة إلى السلة
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () async {
                            await CartDB.instance.addToCart({
                              'product_id': product!['id'],
                              'name': product!['name'],
                              'price': double.parse(
                                  product!['price'].toString()),
                              'quantity': 1,
                              'image': product!['image'],
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Added to cart")),
                            );
                          },
                          icon: Icon(Icons.add_shopping_cart,
                              color: Colors.white),
                          label: Text("Add to Cart",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}