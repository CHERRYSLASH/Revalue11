import '../../products/data/product_model.dart';

abstract class CartEvent {}

class AddProductToCart extends CartEvent {
  final Product product;
  AddProductToCart(this.product);
}

class RemoveProductFromCart extends CartEvent {
  final Product product;
  RemoveProductFromCart(this.product);
}

class ClearCart extends CartEvent {}