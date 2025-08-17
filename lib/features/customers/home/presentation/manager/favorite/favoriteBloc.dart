import 'package:bloc/bloc.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/features/customers/home/data/repositories/favoriteRepository.dart';
import 'favoriteEvent.dart';
import 'favoriteState.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository repository;
  FavoriteBloc({required this.repository})
      : assert(repository != null),
        super(FavoriteInitial());
  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is GetFavorite) {
      final failureOrData =
          await repository.getFavorite(customerId: event.customerId);
      yield failureOrData.fold(
        (failure) {
          return FavoriteListError(errorMessage: mapFailureToMessage(failure));
        },
        (data) {
          return FavoriteLoaded(
            favoriteList: data,
          );
        },
      );
    } else if (event is UpdateFavorite) {
      await repository.updateFavorite(
          Favorite: event.favorite, customerId: event.customerId);
    }
  }
}
