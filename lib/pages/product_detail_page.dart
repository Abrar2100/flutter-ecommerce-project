import 'package:flutter/material.dart';
import '../repositories/api_repository.dart';
import '../database/cart_db.dart';

class ProductDetailPage extends StatefulWidget {
  final String slug;
  const ProductDetailPage({required this.slug, Key? key}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<Map<String, dynamic>> product;

  @override
  void initState() {
    super.initState();
    product = ApiRepository.fetchProductDetails(widget.slug);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Details")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: product,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));

          var data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(data["name"], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Price: ${data["price"]}"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await CartDB.instance.addToCart({
                    "product_id": data["id"],
                    "name": data["name"],
                    "price": double.parse(data["price"].toString()),
                    "quantity": 1,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added to cart")));
                },
                child: Text("Add to Cart"),
              ),
            ]),
          );
        },
      ),
    );
  }
}
