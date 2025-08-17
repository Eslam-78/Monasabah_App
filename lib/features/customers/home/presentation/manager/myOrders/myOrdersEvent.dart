import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/cart/data/models/newOrderModel.dart';

abstract class MyOrdersEvent extends Equatable{
  const MyOrdersEvent();
}

class GetMyOrdersEvent extends MyOrdersEvent {
  final String token;

  GetMyOrdersEvent({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}

class NewOrderEvent extends MyOrdersEvent {
  final NewOrderModel newOrderModel;

  NewOrderEvent({
    required this.newOrderModel,
  });

  @override
  List<Object> get props => [newOrderModel];
}