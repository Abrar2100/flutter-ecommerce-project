class Product {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final double price;
  final String? image;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    this.image,
  });

  // تحويل JSON إلى Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      image: json['image'],
    );
  }

  // تحويل Product إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'price': price,
      'image': image,
    };
  }
}