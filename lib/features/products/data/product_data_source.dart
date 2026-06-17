import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_model.dart';

class ProductRemoteDataSource {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      
      // Convert eah JSON object into a Product model
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products. Status: ${response.statusCode}');
    }
  }
}