import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/features/customers/home/data/repositories/mainMinuRepository.dart';

import 'mainMenuEvent.dart';
import 'mainMinuState.dart';

class MainMenuBloc extends Bloc<MainMenuEvent,MainMenuState>{

  final MainMenuRepository repository;
  MainMenuBloc({required this.repository})
      : assert(repository != null),
        super(MainMenuInitial());
  @override
  Stream<MainMenuState> mapEventToState(MainMenuEvent event)async* {

    if(event is GetMainMenuSections){
      yield MainMenuLoading();
      final failureOrData = await repository.getMainMenuSections(
        token: event.token,
      );
      yield* failureOrData.fold(
            (failure) async* {
              log('yield is error');

              yield MainMenuError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
              log('yield is loaded');
          yield GetMainMenuSectionsLoaded(mainMenuSectionsModel: data);
        },
      );
    }
    if(event is GetMainMenuMostBookedServices){
      yield MainMenuLoading();
      final failureOrData = await repository.getMostBookedServices(
        token: event.token,
      );
      yield* failureOrData.fold(
            (failure) async* {
              log('yield is error');

              yield MainMenuError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
              log('yield is loaded');
          yield GetMainMenuMostBookedServiceLoaded(servicesModel: data);
        },
      );
    }

    if(event is GetMainMenuMostRatedServices){
      yield MainMenuLoading();
      final failureOrData = await repository.getMostRatedServices(
        token: event.token,
      );
      yield* failureOrData.fold(
            (failure) async* {
              log('yield is error');

              yield MainMenuError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
              log('yield is loaded');
          yield GetMainMenuMostRatedServiceLoaded(servicesModel: data);
        },
      );
    }

  }

}