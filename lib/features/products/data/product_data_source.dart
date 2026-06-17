import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_model.dart';

class ProductRemoteDataSource {
  // Use 10.0.2.2 for Android emulator to access localhost, or your local IP for physical devices.
  final String baseUrl = 'http://10.0.2.2:8000/api'; 

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products from server');
    }
  }
}