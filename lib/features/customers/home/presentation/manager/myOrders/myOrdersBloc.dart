import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/features/customers/home/data/repositories/myOrdersRepository.dart';
import 'myOrdersEvent.dart';
import 'myOrdersState.dart';

class MyOrdersBloc extends Bloc<MyOrdersEvent,MyOrdersState>{

  final MyOrdersRepository repository;
  MyOrdersBloc({required this.repository})
      : assert(repository != null),
        super(GetMyOrdersInitial());

  @override
  Stream<MyOrdersState> mapEventToState(MyOrdersEvent event) async*{

    if(event is GetMyOrdersEvent){
      yield GetMyOrdersLoading();
      final failureOrData = await repository.getMyOrders(

        token: event.token,
      );
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');

          yield MyOrdersError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield GetMyOrdersLoaded(myOrdersModel: data);
        },
      );
    }

    if(event is NewOrderEvent){
      yield GetMyOrdersLoading();
      final failureOrData = await repository.newOrder(

        newOrderModel: event.newOrderModel,
      );
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');

          yield MyOrdersError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield NewOrdersLoaded(message: data);
        },
      );
    }

  }



}