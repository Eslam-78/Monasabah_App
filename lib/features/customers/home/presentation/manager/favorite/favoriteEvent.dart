import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
}

class GetFavorite extends FavoriteEvent {
  final int customerId;

  GetFavorite({required this.customerId});
  @override
  List<Object?> get props => [];
}

class UpdateFavorite extends FavoriteEvent {
  final List<dynamic> favorite;
  final int customerId;

  UpdateFavorite({required this.favorite, required this.customerId});

  @override
  List<Object> get props => [favorite];
}
