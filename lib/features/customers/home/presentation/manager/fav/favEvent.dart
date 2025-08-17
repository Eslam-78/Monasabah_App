import 'package:equatable/equatable.dart';

abstract class FavEvent extends Equatable {
  const FavEvent();
}

class GetFavorite extends FavEvent {
  final int customerId;

  GetFavorite({required this.customerId});

  @override
  List<Object?> get props => [customerId];
}

class UpdateFavorite extends FavEvent {
  final int customerId;
  final Map<String, dynamic> favorite;

  UpdateFavorite({required this.customerId, required this.favorite});

  @override
  List<Object?> get props => [customerId, favorite];
}
