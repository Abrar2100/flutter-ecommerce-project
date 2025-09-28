class Links {
  static const String baseUrl = "http://192.168.8.133:8000/api/v1";
  static const String products = "$baseUrl/api/v1/products";
  static String productDetails(String slug) => "$products/$slug";

  static const String categories = "$baseUrl/api/v1/categories";
  static const String login = "$baseUrl/api/v1/auth/login";
  static const String register = "$baseUrl/api/v1/auth/register";
    static const String orders = "$baseUrl/orders";
}


