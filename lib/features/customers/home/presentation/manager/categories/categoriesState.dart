import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/home/data/models/categories/categoriesModel.dart';
import 'package:monasbah/features/customers/home/data/models/mainMenuSectionsModel.dart';

abstract class CategoriesState extends Equatable{
  const CategoriesState();
}

class GetCategoriesInitial extends CategoriesState{
  @override
  List<Object?> get props => [];

}

class GetCategoriesLoading extends CategoriesState{
  @override
  List<Object?> get props => [];

}
class GetCategoriesLoaded extends CategoriesState{
  final List<CategoriesModel>  categoriesModel;

  GetCategoriesLoaded({required this.categoriesModel});

  @override
  List<Object> get props => [categoriesModel];
}

class GetCategoriesError extends CategoriesState {

  final String message;
  GetCategoriesError({required this.message});

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  List<Object> get props => [message];

}
