import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../database/cart_db.dart';
import '../services/link.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> items = [];

  Future<void> loadCart() async {
    var data = await CartDB.instance.getCartItems();
    setState(() {
      items = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> checkout() async {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cart is empty")),
      );
      return;
    }

    // 2️⃣ تجهيز البيانات للـ API
    List<Map<String, dynamic>> orderItems = items.map((item) {
      return {
        "product_id": item['product_id'],
        "qty": item['quantity']
      };
    }).toList();

    var orderData = {
      "items": orderItems,
      "address": {
        "city": "Sanaa",
        "street": "Hadda"
      }
    };

    // 3️⃣ إرسال الطلب إلى Laravel
    var response = await http.post(
      Uri.parse(Links.orders),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      await CartDB.instance.clearCart();
      setState(() {
        items = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order placed successfully!")),
      );
    } else {
      try {
        var error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${error['message']}")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Something went wrong")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("My Cart", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // 🛒 المنتجات
          Expanded(
            child: items.isEmpty
                ? Center(child: Text("Cart is empty"))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.shopping_bag, color: Colors.blue),
                          title: Text(item['name']),
                          subtitle: Text(
                              "${item['price']} \$ x ${item['quantity']}"),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await CartDB.instance.removeItem(item['id']);
                              loadCart();
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // ✅ زر Checkout
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: checkout,
              icon: Icon(Icons.payment, color: Colors.white),
              label: Text("Checkout", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}