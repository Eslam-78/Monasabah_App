import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/cart/data/models/cartModel.dart';
import 'package:monasbah/features/customers/cart/data/models/customerLocationsModel.dart';

abstract class CartState extends Equatable{
  const CartState();
}

class CartInitial extends CartState{
  @override
  List<Object?> get props => [];

}

class CartLoading extends CartState {
  @override
  List<Object> get props => [];
}

class CartLoaded extends CartState {
  final List<CartModel> cartList;
  CartLoaded({required this.cartList});

  @override
  List<Object> get props => [cartList];
}

class CartListError extends CartState {
  final String errorMessage;

  CartListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}