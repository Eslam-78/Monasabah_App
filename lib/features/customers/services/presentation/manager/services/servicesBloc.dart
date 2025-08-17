import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/features/customers/services/presentation/manager/services/servicesEvent.dart';

import 'package:monasbah/features/customers/services/data/repositories/servicesRepository.dart';
import 'package:monasbah/features/customers/services/presentation/manager/services/servicesState.dart';
import 'package:dio/dio.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final ServicesRepository repository;
  ServicesBloc({required this.repository})
      : assert(repository != null),
        super(GetServicesInitial());
  @override
  Stream<ServicesState> mapEventToState(ServicesEvent event) async* {
    /* final dio = Dio();*/

    if (event is GetServices) {
      yield GetServicesLoading();
      final failureOrData =
          await repository.getServicesOfSection(section_id: event.section_id);
      yield* failureOrData.fold(
        (failure) async* {
          log('yield is error');
          yield GetServicesError(errorMessage: mapFailureToMessage(failure));
        },
        (data) async* {
          log('yield is loaded');
          yield GetServicesLoaded(servicesModel: data);
        },
      );
    }

    if (event is GetServiceProviderServices) {
      yield GetServicesLoading();
      final failureOrData =
          await repository.getServiceProviderServices(token: event.token);
      yield* failureOrData.fold(
        (failure) async* {
          log('yield is error');
          yield GetServicesError(errorMessage: mapFailureToMessage(failure));
        },
        (data) async* {
          log('yield is loaded');
          yield GetServicesLoaded(servicesModel: data);
        },
      );
    }

    if (event is GetServicesByName) {
      yield GetServicesLoading();
      final failureOrData = await repository.getServicesByName(
          section_id: event.section_id, serviceName: event.serviceName);
      yield* failureOrData.fold(
        (failure) async* {
          log('yield is error');
          yield GetServicesError(errorMessage: mapFailureToMessage(failure));
        },
        (data) async* {
          log('yield is loaded');
          yield GetServicesLoaded(servicesModel: data);
        },
      );
    }

    if (event is GetServicesByDate) {
      yield GetServicesLoading();
      final failureOrData = await repository.getServicesByDate(
          section_id: event.section_id, date: event.date);
      yield* failureOrData.fold(
        (failure) async* {
          log('yield is error');
          yield GetServicesError(errorMessage: mapFailureToMessage(failure));
        },
        (data) async* {
          log('yield is loaded');
          yield GetServicesLoaded(servicesModel: data);
        },
      );
    }

    if (event is GetServicesByPrice) {
      yield GetServicesLoading();
      final failureOrData = await repository.getServicesByPrice(
          section_id: event.section_id,
          priceFrom: event.priceFrom,
          priceTo: event.priceTo);
      yield* failureOrData.fold(
        (failure) async* {
          log('yield is error');
          yield GetServicesError(errorMessage: mapFailureToMessage(failure));
        },
        (data) async* {
          log('yield is loaded');
          yield GetServicesLoaded(servicesModel: data);
        },
      );
    }

    if (event is GetServicesByScale) {
      yield GetServicesLoading();
      final failureOrData = await repository.getServicesByScale(
          section_id: event.section_id,
          scaleFrom: event.scaleFrom,
          scaleTo: event.scaleTo);
      yield* failureOrData.fold(
        (failure) async* {
          log('yield is error');
          yield GetServicesError(errorMessage: mapFailureToMessage(failure));
        },
        (data) async* {
          log('yield is loaded');
          yield GetServicesLoaded(servicesModel: data);
        },
      );
    }

    if (event is CacheService) {
      repository.cacheService(servicesModel: event.servicesModel);
    }

    if (event is AddNewService) {
      yield Loading();
      final failureOrData = await repository.addNewService(
        addNewServiceModel: event.addNewServiceModel,
      );
      yield* failureOrData.fold(
        (failure) async* {
          log('yield is error');

          yield Error(errorMessage: mapFailureToMessage(failure));
        },
        (data) async* {
          log('yield is loaded');
          yield Loaded(message: data);
        },
      );
    }

    /*   if (event is RemoveService) {
      yield Loading();
      try {
        await dio.delete('http://192.168.0.124/api/serviceProvider/delete/provider/service', data: {'id': event.id});
        yield Loaded(message: 'تم حذف الخدمة بنجاح.');
      } catch (e) {
        yield Error(errorMessage: 'حدث خطأ أثناء حذف الخدمة.');
      }
    }*/
    if (event is RemoveService) {
      print("تم استقبال حدث الحذف");
      yield GetServicesLoading();
      final failureOrData =
          await repository.removeService(id: event.id, token: event.token);
      yield* failureOrData.fold(
        (failure) async* {
          log('yield is error');
          yield GetServicesError(errorMessage: mapFailureToMessage(failure));
        },
        (data) async* {
          log('yield is loaded');
          final updatedServices =
              await repository.getServiceProviderServices(token: event.token);
          yield* updatedServices.fold(
            (failure) async* {
              log('yield is error');
              yield GetServicesError(
                  errorMessage: mapFailureToMessage(failure));
            },
            (services) async* {
              log('yield is loaded');
              yield GetServicesLoaded(servicesModel: services);
            },
          );
        },
      );
    }

    if (event is AddNewServiceImage) {
      yield Loading();
      final failureOrData =
          await repository.addNewServiceImage(id: event.id, image: event.image);
      yield* failureOrData.fold(
        (failure) async* {
          log('yield is error');

          yield Error(errorMessage: mapFailureToMessage(failure));
        },
        (data) async* {
          log('yield is loaded');
          yield Loaded(message: data);
        },
      );
    }

    if (event is AddToFavorite) {
      final failureOrData = await repository.addToFavorite(
        servicesModel: event.servicesModel,
        customerId: event.customerId,
      );
      if (failureOrData) {
        yield ServiceAddedToFavorite();
      } else {
        yield ServiceAddedToFavoriteError(
            message: 'حدثت مشكلة أثناء الاضافة الى المفضله!');
      }
    }
  }
}
