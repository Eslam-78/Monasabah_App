import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/features/customers/services/data/repositories/servicesReservationsRepository.dart';
import 'package:monasbah/features/customers/services/presentation/manager/serviceReservations/servicesReservationsEvent.dart';
import 'package:monasbah/features/customers/services/presentation/manager/serviceReservations/servicesReservationsState.dart';

class ServicesReservationsBloc extends Bloc<ServicesReservationsEvent,ServicesReservationsState>{

  final ServicesReservationsRepository repository;
  ServicesReservationsBloc({required this.repository})
      : assert(repository != null),
        super(ServicesReservationsInitial());
  @override
  Stream<ServicesReservationsState> mapEventToState(ServicesReservationsEvent event)async* {

    if(event is GetServiceReservations){
      yield GetServicesReservationsLoading();
      final failureOrData = await repository.getServicesReservations(service_id: event.service_id);
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield ServicesReservationsError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield GetServicesReservationsLoaded(servicesReservationsModel: data,);
        },
      );
    }

    if(event is GetHighlightedDates){
      yield GetServicesReservationsLoading();
      final failureOrData = await repository.getHighlightedDates(service_id: event.service_id,reserveDate: event.reserveDate);
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield ServicesReservationsError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield GetServicesReservationsLoaded(servicesReservationsModel: data,);
        },
      );
    }

    if(event is GetServiceReservationsOfCustomer){
      yield GetServicesReservationsLoading();
      final failureOrData = await repository.getServicesReservationsOfCustomer(token:  event.token);
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield ServicesReservationsError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield GetServicesReservationsLoaded(servicesReservationsModel: data,);
        },
      );
    }

    if(event is AddServiceReservation){
      final failureOrData = await repository.addServiceReservation(service_id: event.service_id,api_token: event.api_token,reserveDate: event.reserveDate,service_reservation_price: event.service_reservation_price);
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield ServicesReservationsError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield AddServiceReservationsLoaded(message: data);
        },
      );
    }

    if(event is BlockDateReservation){
      final failureOrData = await repository.blockDateReservation(service_id: event.service_id,reserveDate: event.reserveDate,service_reservation_price: event.service_reservation_price,blockUnBlock: event.blockUnBlock);
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield ServicesReservationsError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield AddServiceReservationsLoaded(message: data);
        },
      );
    }

    if(event is AcceptReservation){
      final failureOrData = await repository.acceptReservation(service_id: event.service_id,customer_id:  event.customer_id,reserveDate: event.reserveDate);
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield ServicesReservationsError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield AcceptReservationLoaded(message: data);
        },
      );
    }

    if(event is DeclineReservation){
      final failureOrData = await repository.declineReservation(token: event.token,id:  event.id);
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield ServicesReservationsError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield DeclineReservationLoaded(message: data);
        },
      );
    }

  }


}