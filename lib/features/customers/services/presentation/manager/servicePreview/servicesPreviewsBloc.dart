import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/features/customers/services/data/repositories/servicePreviewsRepository.dart';
import 'package:monasbah/features/customers/services/presentation/manager/servicePreview/servicesPreviewsEvent.dart';
import 'package:monasbah/features/customers/services/presentation/manager/servicePreview/servicesPreviewsState.dart';

class ServicesPreviewsBloc
    extends Bloc<ServicesPreviewsEvent, ServicesPreviewsState> {
  final ServicesPreviewsRepository repository;
  ServicesPreviewsBloc({required this.repository})
      : assert(repository != null),
        super(ServicesPreviewInitial());
  @override
  Stream<ServicesPreviewsState> mapEventToState(
      ServicesPreviewsEvent event) async* {
    if (event is GetServicePreview) {
      yield GetServicesPreviewsLoading();
      final failureOrData =
          await repository.getServicesPreview(service_id: event.service_id);
      yield* failureOrData.fold(
        (failure) async* {
          log('yield is error');
          yield ServicesPreviewsError(
              errorMessage: mapFailureToMessage(failure));
        },
        (data) async* {
          log('yield is loaded');
          yield GetServicesPreviewsLoaded(
            servicesPreviewsModel: data,
          );
        },
      );
    }

    if (event is AddServicePreview) {
      yield GetServicesPreviewsLoading();
      final failureOrData = await repository.addServicePreview(
          service_id: event.service_id,
          api_token: event.api_token,
          preview: event.preview);
      yield* failureOrData.fold(
        (failure) async* {
          log('yield is error');
          yield ServicesPreviewsError(
              errorMessage: mapFailureToMessage(failure));
        },
        (data) async* {
          log('yield is loaded');
          yield AddServicePreviewLoaded(message: data);
        },
      );
    }
    if (event is DeleteServicePreview) {
      yield GetServicesPreviewsLoading();
      final failureOrData = await repository.deleteServicePreview(
          service_id: event.service_id, api_token: event.api_token);
      yield* failureOrData.fold(
        (failure) async* {
          log('yield is error');
          yield ServicesPreviewsError(
              errorMessage: mapFailureToMessage(failure));
        },
        (data) async* {
          log('yield is loaded');
          yield DeleteServicePreviewLoaded(message: data);
        },
      );
    }
  }
}
