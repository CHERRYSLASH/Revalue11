import '../data/cart_item_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<CartItem> items;
  final double grandTotal;

  CartUpdated({required this.items, required this.grandTotal});
}