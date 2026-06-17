import '../data/product_model.dart';
import '../data/product_data_source.dart';

class ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepository({required this.remoteDataSource});

  Future<List<Product>> getProducts() async {
    try {
      return await remoteDataSource.fetchProducts();
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
