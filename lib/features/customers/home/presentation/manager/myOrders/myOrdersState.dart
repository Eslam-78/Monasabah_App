import 'package:equatable/equatable.dart';

import '../../../data/models/MyOrders/MyOrdersModel.dart';

abstract class MyOrdersState extends Equatable{
  const MyOrdersState();
}

class GetMyOrdersInitial extends MyOrdersState{
  @override
  List<Object?> get props => [];

}

class GetMyOrdersLoading extends MyOrdersState{
  @override
  List<Object?> get props => [];

}
class GetMyOrdersLoaded extends MyOrdersState{
  final List<MyOrdersModel>  myOrdersModel;

  GetMyOrdersLoaded({required this.myOrdersModel});

  @override
  List<Object> get props => [MyOrdersModel];
}

class NewOrdersLoaded extends MyOrdersState{
  final String message;

  NewOrdersLoaded({required this.message});

  @override
  List<Object> get props => [MyOrdersModel];
}

class MyOrdersError extends MyOrdersState {

  final String errorMessage;
  MyOrdersError({required this.errorMessage});

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  List<Object> get props => [errorMessage];

}
