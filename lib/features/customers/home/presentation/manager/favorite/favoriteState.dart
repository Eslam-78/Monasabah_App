import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';

abstract class FavoriteState extends Equatable{
  const FavoriteState();
}

class FavoriteInitial extends FavoriteState{
  @override
  List<Object?> get props => [];

}

class FavoriteLoading extends FavoriteState {
  @override
  List<Object> get props => [];
}

class FavoriteLoaded extends FavoriteState {
  final List<ServicesModel> favoriteList;
  FavoriteLoaded({required this.favoriteList});

  @override
  List<Object> get props => [favoriteList];
}

class FavoriteListError extends FavoriteState {
  final String errorMessage;

  FavoriteListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}