class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });

  // This is the magic method your data source is looking for!
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      // We use .toString() safely in case the ID comes back as an integer
      id: json['id'].toString(), 
      name: json['name'] ?? 'Unknown Product',
      
      // Using ?? provides a safe default in case the API forgets to send these
      description: json['description'] ?? 'No description available',
      
      // Safely convert the price whether it comes in as an int (24) or double (24.99)
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      
      stock: json['stock'] ?? 0,
      imageUrl: json['imageUrl'] ?? '', 
    );
  }
}