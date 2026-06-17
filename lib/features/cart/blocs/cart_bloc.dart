import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../data/cart_item_model.dart';

class CartBloc extends Bloc<CartEvent, CartState> {

  final List<CartItem> _cartItems = [];

  CartBloc() : super(CartInitial()) {
    

    on<AddProductToCart>((event, emit) {

      final existingItemIndex = _cartItems.indexWhere(
        (item) => item.product.id == event.product.id,
      );

      if (existingItemIndex >= 0) {

        _cartItems[existingItemIndex].quantity += 1;
      } else {

        _cartItems.add(CartItem(product: event.product));
      }

      _emitUpdatedState(emit);
    });


    on<RemoveProductFromCart>((event, emit) {
      _cartItems.removeWhere((item) => item.product.id == event.product.id);
      
      _emitUpdatedState(emit);
    });


    on<ClearCart>((event, emit) {
      _cartItems.clear();
      emit(CartInitial());
    });
  }


  void _emitUpdatedState(Emitter<CartState> emit) {
    double total = 0;
    
    for (var item in _cartItems) {
      total += (item.product.price * item.quantity);
    }


    emit(CartUpdated(items: List.from(_cartItems), grandTotal: total));
  }
}