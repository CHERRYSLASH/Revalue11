import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../blocs/cart_state.dart';
import '../blocs/cart_event.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Check the look', style: TextStyle(fontSize: 16)),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartInitial || (state is CartUpdated && state.items.isEmpty)) {
            return const Center(
              child: Text('Your rack is empty.', style: TextStyle(color: Colors.grey)),
            );
          }

          if (state is CartUpdated) {
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: state.items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 24),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dark Image Placeholder (Falls back gracefully if no image)
                          Container(
                            width: 80,
                            height: 90,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E), 
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: item.product.imageUrl.isNotEmpty
                                ? Image.network(
                                    item.product.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.image, color: Colors.white24),
                                  )
                                : const Icon(Icons.image, color: Colors.white24),
                          ),
                          const SizedBox(width: 16),
                          
                          // Details Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.product.name,
                                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Delete Option
                                    GestureDetector(
                                      onTap: () {
                                        context.read<CartBloc>().add(RemoveProductFromCart(item.product));
                                      },
                                      child: const Icon(Icons.close, color: Colors.grey, size: 20),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                
                                // Size and Color Chips
                                Row(
                                  children: [
                                    _buildChip('Size: M'), // Hardcoded for UI aesthetic
                                    const SizedBox(width: 8),
                                    _buildChip('Color: Black'),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                
                                // Price
                                Text(
                                  '\$${item.product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                
                // Bottom Checkout Bar
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total: \$${state.grandTotal.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              // Simulate Checkout Success
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Order placed successfully! 📦'),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              Navigator.pop(context); // Return to previous screen
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'PLACE ORDER',
                              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // Helper widget for the sleek pill chips
  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade800),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
      ),
    );
  }
}