import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/home/data/models/categories/categoriesModel.dart';
import 'package:monasbah/features/customers/home/data/models/mainMenuSectionsModel.dart';
import 'package:monasbah/features/customers/home/data/models/categories/productsModel.dart';

abstract class ProductsState extends Equatable{
  const ProductsState();
}

class GetSubCategoriesInitial extends ProductsState{
  @override
  List<Object?> get props => [];

}

class GetSubCategoriesLoading extends ProductsState{
  @override
  List<Object?> get props => [];

}

class GeSubCategoriesLoaded extends ProductsState{
  final List<ProductsModel>  productsModel;

  GeSubCategoriesLoaded({required this.productsModel});

  @override
  List<Object> get props => [productsModel];
}

class GetSubCategoriesError extends ProductsState {

  final String message;
  GetSubCategoriesError({required this.message});

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  List<Object> get props => [message];

}

class ProductAddedToCart extends ProductsState{
  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  List<Object> get props => [];
}

class ProductAddedToCartError extends ProductsState {
  final String message;

  ProductAddedToCartError({required this.message});

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  List<Object> get props => [message];
}
