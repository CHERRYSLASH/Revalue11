import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../data/cart_item_model.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  // Keeps track of the cart in memory globally
  final List<CartItem> _cartItems = [];

  CartBloc() : super(CartInitial()) {
    
    // Handle Adding Items
    on<AddProductToCart>((event, emit) {
      // Check if the product is already in the cart
      final existingItemIndex = _cartItems.indexWhere(
        (item) => item.product.id == event.product.id,
      );

      if (existingItemIndex >= 0) {
        // If it exists, just bump up the quantity
        _cartItems[existingItemIndex].quantity += 1;
      } else {
        // If it's new, add it as a new CartItem
        _cartItems.add(CartItem(product: event.product));
      }

      _emitUpdatedState(emit);
    });

    // Handle Removing Items (Hitting the 'X' button)
    on<RemoveProductFromCart>((event, emit) {
      _cartItems.removeWhere((item) => item.product.id == event.product.id);
      
      _emitUpdatedState(emit);
    });

    // Handle Checking Out (Clearing the cart)
    on<ClearCart>((event, emit) {
      _cartItems.clear();
      emit(CartInitial());
    });
  }

  // A private helper function to calculate the total and push the update
  void _emitUpdatedState(Emitter<CartState> emit) {
    double total = 0;
    
    for (var item in _cartItems) {
      total += (item.product.price * item.quantity);
    }

    // We pass List.from() to create a fresh copy so the UI knows to rebuild
    emit(CartUpdated(items: List.from(_cartItems), grandTotal: total));
  }
}