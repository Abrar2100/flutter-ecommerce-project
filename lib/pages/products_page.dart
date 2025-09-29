import 'package:flutter/material.dart';
import '../repositories/api_repository.dart';

class ProductsPage extends StatefulWidget {
  final int? categoryId;
  const ProductsPage({this.categoryId, Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<Map<String, dynamic>> products;

  @override
  void initState() {
    super.initState();
    products = ApiRepository.fetchProducts(categoryId: widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Products")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));

          var list = snapshot.data!["data"];
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              var product = list[index];
              return ListTile(
                title: Text(product["name"]),
                subtitle: Text("Price: ${product["price"]}"),
                onTap: () {
                  Navigator.pushNamed(context, "/product_detail", arguments: product["slug"]);
                },
              );
            },
          );
        },
      ),
    );
  }
}

