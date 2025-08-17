import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/features/customers/home/data/repositories/categoriesRepository.dart';
import 'categoriesEvent.dart';
import 'categoriesState.dart';

class CategoriesBloc extends Bloc<CategoriesEvent,CategoriesState>{

  final CategoriesRepository repository;
  CategoriesBloc({required this.repository})
      : assert(repository != null),
        super(GetCategoriesInitial());

  @override
  Stream<CategoriesState> mapEventToState(CategoriesEvent event) async*{

    if(event is GetCategoriesEvent){
      yield GetCategoriesLoading();
      final failureOrData = await repository.getCategories(

        token: event.token,
      );
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');

          yield GetCategoriesError(message: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield GetCategoriesLoaded(categoriesModel: data);
        },
      );
    }
  }



}