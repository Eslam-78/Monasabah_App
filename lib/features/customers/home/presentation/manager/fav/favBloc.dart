import 'package:bloc/bloc.dart';
import 'package:monasbah/features/customers/home/presentation/manager/fav/favEvent.dart';
import 'package:monasbah/features/customers/home/presentation/manager/fav/favState.dart';

import '../../pages/favoriteservice.dart';


class FavBloc extends Bloc<FavEvent, FavState> {
  final FavoriteService favoriteService;

  FavBloc({required this.favoriteService}) : super(FavoriteInitial());

  @override
  Stream<FavState> mapEventToState(FavEvent event) async* {
    if (event is GetFavorite) {
      final favoriteList = await favoriteService.getFavorites(event.customerId);
      if (favoriteList.isNotEmpty) {
        yield FavoriteLoaded(favoriteList: favoriteList);
      } else {
        yield FavoriteListError(errorMessage: 'المفضلة فارغة.');
      }
    } else if (event is UpdateFavorite) {
      await favoriteService.addToFavorites(event.customerId, event.favorite);
      final updatedList = await favoriteService.getFavorites(event.customerId);
      yield FavoriteLoaded(favoriteList: updatedList);
    }
  }
}
