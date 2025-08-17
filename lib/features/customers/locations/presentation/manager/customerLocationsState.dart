import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/cart/data/models/customerLocationsModel.dart';

abstract class CustomerLocationsState extends Equatable{
  const CustomerLocationsState();
}

class GetCustomerLocationsInitial extends CustomerLocationsState{
  @override
  List<Object?> get props => [];

}

class GetCustomerLocationsLoading extends CustomerLocationsState{
  @override
  List<Object?> get props => [];

}

class GetCustomerLocationsLoaded extends CustomerLocationsState{
  final List<CustomerLocationsModel>  customerLocationsModel;

  GetCustomerLocationsLoaded({required this.customerLocationsModel});

  @override
  List<Object> get props => [customerLocationsModel];
}

class GetCustomerLocationsError extends CustomerLocationsState {

  final String errorMessage;
  GetCustomerLocationsError({required this.errorMessage});

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  List<Object> get props => [errorMessage];

}

class CustomerLocationsAdding extends CustomerLocationsState{
  @override
  List<Object?> get props => [];
}

class CustomerLocationsAdded extends CustomerLocationsState{
  final String  message;

  CustomerLocationsAdded({required this.message});

  @override
  List<Object> get props => [message];
}

class AddNewCustomerLocationsError extends CustomerLocationsState {

  final String errorMessage;
  AddNewCustomerLocationsError({required this.errorMessage});

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  List<Object> get props => [errorMessage];

}

class RemoveCustomerLocationLoading extends CustomerLocationsState{
  @override
  List<Object?> get props => [];

}

class RemoveCustomerLocationDone extends CustomerLocationsState{
  String message;

  RemoveCustomerLocationDone({required this.message});

  @override
  List<Object?> get props => [message];

}

class RemoveCustomerLocationError extends CustomerLocationsState{
  String errorMessage;

  RemoveCustomerLocationError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];

}
