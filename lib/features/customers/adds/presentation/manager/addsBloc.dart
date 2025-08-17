import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/features/customers/adds/data/repositories/addsRepository.dart';
import 'package:monasbah/features/customers/adds/presentation/manager/addsEvent.dart';
import 'package:monasbah/features/customers/adds/presentation/manager/addsState.dart';

class AddsBloc extends Bloc<AddsEvent,AddsState>{

  final AddsRepository repository;
  AddsBloc({required this.repository})
      : assert(repository != null),
        super(GetAddsInitial());
  @override
  Stream<AddsState> mapEventToState(AddsEvent event)async* {

    if(event is GetAllAdds){
      yield GetAddsLoading();
      final failureOrData = await repository.getAllAdds();
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');

          yield GetAddsError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield GetAddsLoaded(addsModel: data);
        },
      );
    }
    
    if(event is GetSectionAdds){
      yield GetAddsLoading();
      final failureOrData = await repository.getAddsOfSection(section_id: event.sections_id);
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');

          yield GetAddsError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield GetAddsLoaded(addsModel: data);
        },
      );
    }

  }

}