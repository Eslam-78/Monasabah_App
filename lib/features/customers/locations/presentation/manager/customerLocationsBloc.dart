import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/features/customers/locations/data/repository/customerLocationsRepository.dart';

import 'customerLocationsEvent.dart';
import 'customerLocationsState.dart';

class CustomerLocationsBloc
    extends Bloc<CustomerLocationsEvent, CustomerLocationsState> {
  final CustomerLocationsRepository repository;
  CustomerLocationsBloc({required this.repository})
      : assert(repository != null),
        super(GetCustomerLocationsInitial());
  @override
  Stream<CustomerLocationsState> mapEventToState(
      CustomerLocationsEvent event) async* {
    if (event is GetCustomerLocations) {
      yield GetCustomerLocationsLoading();
      final failureOrData = await repository.getCustomerLocations(
        api_token: event.api_token,
      );
      yield* failureOrData.fold(
        (failure) async* {
          log('yield is error');
          yield AddNewCustomerLocationsError(
              errorMessage: mapFailureToMessage(failure));
        },
        (data) async* {
          log('yield is loaded');
          yield GetCustomerLocationsLoaded(customerLocationsModel: data);
        },
      );
    }


    if (event is AddNewCustomerLocation) {
      yield CustomerLocationsAdding();
      final failureOrData = await repository.addNewCustomerAddress(
          api_token: event.api_token,
          locationName: event.locationName,
          description: event.description,
          lat: event.lat,
          long: event.long
      );
      yield* failureOrData.fold(
        (failure) async* {
          log('yield is error');
          yield AddNewCustomerLocationsError(
              errorMessage: mapFailureToMessage(failure));
        },
        (data) async* {
          log('yield is loaded');
          yield CustomerLocationsAdded(message: data);
        },
      );
    }

    if (event is RemoveCustomerLocation) {
      yield RemoveCustomerLocationLoading();
      final failureOrData = await repository.removeCustomerAddress(
          token: event.token, id: event.id);
      yield* failureOrData.fold(
        (failure) async* {
          log('yield is error');
          yield RemoveCustomerLocationError(
              errorMessage: mapFailureToMessage(failure));
        },
        (data) async* {
          log('yield is loaded');
          yield RemoveCustomerLocationDone(message: data);
        },
      );
    }
  }
}
