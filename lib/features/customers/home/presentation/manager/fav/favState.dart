import 'package:equatable/equatable.dart';

abstract class FavState extends Equatable {
  const FavState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavState {}

class FavoriteLoaded extends FavState {
  final List<Map<String, dynamic>> favoriteList;

  FavoriteLoaded({required this.favoriteList});

  @override
  List<Object> get props => [favoriteList];
}

class FavoriteListError extends FavState {
  final String errorMessage;

  FavoriteListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
