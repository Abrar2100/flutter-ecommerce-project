
class Links {
  static const String baseUrl = "http://192.168.8.133:8000/api/v1"; // عدلي الـ IP

  static const String login = "$baseUrl/auth/login";
  static const String register = "$baseUrl/auth/register";
  static const String categories = "$baseUrl/categories";
  static const String products = "$baseUrl/products";
  static String productDetails(String slug) => "$baseUrl/products/$slug";
}
