import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product_bloc.dart';
import '../blocs/product_state.dart';
import '../../cart/blocs/cart_bloc.dart';
import '../../cart/blocs/cart_event.dart';
import '../data/product_model.dart';
import '../../cart/presentation/cart_screen.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dream Rack', style: TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildTopToggle(),
          
          const SizedBox(height: 8),

          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (state is ProductError) {
                  return Center(
                    child: Text(state.message, style: const TextStyle(color: Colors.red)),
                  );
                }

                if (state is ProductLoaded) {
                  if (state.products.isEmpty) {
                    return const Center(child: Text("No products found on server.", style: TextStyle(color: Colors.grey)));
                  }
                  return _buildProductGrid(state.products);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          
          const SizedBox(height: 100), 
        ],
      ),
    );
  }

  Widget _buildTopToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E), // Dark grey background
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.transparent, // Inactive
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text('LOOKS', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white, // Active
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text('PRODUCTS', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65, // Taller aspect ratio for clothing images
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        print("DEBUG: Loading URL -> '${product.imageUrl}'");
        return GestureDetector(
          onTap: () {
            // Adds the item directly to the global cart BLoC!
            context.read<CartBloc>().add(AddProductToCart(product));
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.name} added to cart'),
                duration: const Duration(seconds: 1),
                backgroundColor: const Color(0xFF1E1E1E),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Container
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF161616), // Deep charcoal
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias, // Ensures images respect the rounded corners
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator(color: Colors.white24));
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.checkroom, color: Colors.white24, size: 50));
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Price
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 14
                ),
              ),
              const SizedBox(height: 4),
              
              Text(
                '@${product.name.replaceAll(' ', '').toLowerCase()}', 
                style: const TextStyle(
                  color: Colors.grey, 
                  fontSize: 12
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}