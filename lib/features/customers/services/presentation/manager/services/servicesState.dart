import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';

abstract class ServicesState extends Equatable{
  const ServicesState();
}

class GetServicesInitial extends ServicesState{
  @override
  List<Object?> get props => [];

}

class GetServicesLoading extends ServicesState{
  @override
  List<Object?> get props => [];

}

class GetServicesLoaded extends ServicesState{
  final List<ServicesModel>  servicesModel;

  GetServicesLoaded({required this.servicesModel});

  @override
  List<Object> get props => [servicesModel];
}

class GetServicesError extends ServicesState {

  final String errorMessage;
  GetServicesError({required this.errorMessage});

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  List<Object> get props => [errorMessage];

}

class Loading extends ServicesState{
  @override
  List<Object?> get props => [];

}

class Loaded extends ServicesState{

  String message;
  Loaded({required this.message});

  @override
  List<Object> get props => [message];
}

class Error extends ServicesState {

  final String errorMessage;
  Error({required this.errorMessage});

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  List<Object> get props => [errorMessage];

}

class ServiceAddedToFavorite extends ServicesState{
  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  List<Object> get props => [];
}

  class ServiceAddedToFavoriteError extends ServicesState {
  final String message;

  ServiceAddedToFavoriteError({required this.message});

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  List<Object> get props => [message];
}


class ServiceRemoved extends ServicesState {
  final String message;
  ServiceRemoved({required this.message});
  @override
  List<Object?> get props => [message];
}




