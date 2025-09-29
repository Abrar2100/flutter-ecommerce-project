import 'package:flutter/material.dart';
import '../repositories/api_repository.dart';

class CategoriesPage extends StatefulWidget {
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Future<List<dynamic>> categories;

  @override
  void initState() {
    super.initState();
    categories = ApiRepository.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Categories")),
      body: FutureBuilder<List<dynamic>>(
        future: categories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var cat = snapshot.data![index];
              return ListTile(
                title: Text(cat["name"]),
                onTap: () {
                  Navigator.pushNamed(context, "/products", arguments: cat["id"]);
                },
              );
            },
          );
        },
      ),
    );
  }
}
