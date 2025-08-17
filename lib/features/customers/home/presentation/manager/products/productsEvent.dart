import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/cart/data/models/cartModel.dart';
import 'package:monasbah/features/customers/cart/data/models/cartModel.dart';
import 'package:monasbah/features/customers/home/data/models/categories/productsModel.dart';

abstract class ProductsEvent extends Equatable{
  const ProductsEvent();
}

class GetProductsEvent extends ProductsEvent {
  final String token;
  final String categoryId;
  GetProductsEvent({
    required this.token,
    required this.categoryId
  });

  @override
  List<Object> get props => [token,categoryId];
}

class AddToCartEvent extends ProductsEvent{
  CartModel cartModel;

  AddToCartEvent({required this.cartModel});

  @override
  List<Object?> get props => [cartModel];

}