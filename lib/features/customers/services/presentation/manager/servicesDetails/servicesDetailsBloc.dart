import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/features/customers/services/data/repositories/servicesDetailsRepository.dart';
import 'package:monasbah/features/customers/services/presentation/manager/servicesDetails/servicesDetailsEvent.dart';
import 'package:monasbah/features/customers/services/presentation/manager/servicesDetails/servicesDetailsState.dart';

class ServicesDetailsBloc extends Bloc<ServicesDetailsEvent,ServicesDetailsState>{

  final ServicesDetailsRepository repository;
  ServicesDetailsBloc({required this.repository})
      : assert(repository != null),
        super(ServicesDetailsInitial());
  @override
  Stream<ServicesDetailsState> mapEventToState(ServicesDetailsEvent event)async* {

    if(event is GetServicesRating){
      yield ServicesDetailsLoading();
      final failureOrData = await repository.getServicesRating(service_id: event.service_id);
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield ServicesDetailsError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield GetServiceRateLoaded(serviceRatingModel: data,);
        },
      );
    }

    if(event is GetServiceImages){
      yield ServicesDetailsLoading();
      final failureOrData = await repository.getServicesImages(service_id: event.service_id);
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield ServicesDetailsError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield GetServicesImagesLoaded(servicesImagesModel:data);
        },
      );
    }



    if(event is GetCustomerServiceRating){
      yield ServicesDetailsLoading();
      final failureOrData = await repository.getCustomerServiceRating(service_id: event.service_id,token: event.token);
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield ServicesDetailsError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield GetCustomerServiceRateLoaded(rate:data,);
        },
      );
    }

    if(event is AddCustomerServicesRate){
      yield ServicesDetailsLoading();
      final failureOrData = await repository.addCustomerServicesRate(service_id: event.service_id,token: event.token,rate: event.rate);
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield ServicesDetailsError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield AddCustomerServiceRate(message:data,);
        },
      );
    }

    if(event is EditServiceDetails){
      yield ServicesDetailsLoading();
      final failureOrData = await repository.editServiceDetails(editServiceModel: event.editServiceModel);
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield ServicesDetailsError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield EditServiceDetailsDone(message:'تم التعديل بنجاح');
        },
      );
    }

  }


}