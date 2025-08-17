import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/data/repository/serviceProviderRepository.dart';
import 'citiesEvent.dart';
import 'citiesState.dart';

class CitiesBloc extends Bloc<CitiesEvent,CitiesState>{

  final ServiceProviderRepository repository;
  CitiesBloc({required this.repository})
      : assert(repository != null),
        super(GetCitiesInitial());
  @override
  Stream<CitiesState> mapEventToState(CitiesEvent event)async* {

    if(event is GetCities){
      yield GetCitiesLoading();
      final failureOrData = await repository.getCities(
        token: event.token,
      );
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');

          yield GetCitiesError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield GetCitiesLoaded(citiesModel: data);
        },
      );
    }

  }

}