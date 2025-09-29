import 'package:flutter/material.dart';
import '../database/cart_db.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> items = [];

  Future<void> loadCart() async {
    var data = await CartDB.instance.getCartItems();
    setState(() => items = data);
  }

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: items.isEmpty
          ? Center(child: Text("Cart is empty"))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index];
                return ListTile(
                  title: Text(item["name"]),
                  subtitle: Text("Qty: ${item["quantity"]} | Price: ${item["price"]}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await CartDB.instance.deleteItem(item["id"]);
                      loadCart();
                    },
                  ),
                );
              },
            ),
    );
  }
}