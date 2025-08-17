import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/cart/data/models/cartModel.dart';
import 'package:monasbah/features/customers/cart/data/models/customerLocationsModel.dart';

abstract class CartEvent extends Equatable{
  const CartEvent();
}

class GetCart extends CartEvent{
  @override
  List<Object?> get props => [];

}

class UpdateCart extends CartEvent {
  final List<dynamic> cart;

  UpdateCart({
    required this.cart,
  });

  @override
  List<Object> get props => [cart];
}