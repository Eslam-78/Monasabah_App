import 'package:equatable/equatable.dart';

import 'package:monasbah/features/customers/services/data/models/servicePreviewsModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesImageModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesReservationsModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesReservationsModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesReservationsModel.dart';

abstract class ServicesReservationsState extends Equatable{
  const ServicesReservationsState();
}

///common
class ServicesReservationsInitial extends ServicesReservationsState{
  @override
  List<Object?> get props => [];

}

class GetServicesReservationsLoading extends ServicesReservationsState{
  @override
  List<Object?> get props => [];

}

class GetServicesReservationsLoaded extends ServicesReservationsState{
  final List<ServicesReservationsModel>  servicesReservationsModel;

  GetServicesReservationsLoaded({required this.servicesReservationsModel});

  @override
  List<Object> get props => [ServicesReservationsModel];


}

class AddServiceReservationsLoaded extends ServicesReservationsState{
  final String message ;

  AddServiceReservationsLoaded({required this.message});

  @override
  List<Object?> get props => [message];

}

class AcceptReservationLoaded extends ServicesReservationsState{
  String message;

  AcceptReservationLoaded({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props =>[message];

}

class DeclineReservationLoaded extends ServicesReservationsState{
  String message;

  DeclineReservationLoaded({required this.message});

  @override
  List<Object?> get props =>[message];

}


class ServicesReservationsError extends ServicesReservationsState {

  final String errorMessage;
  ServicesReservationsError({required this.errorMessage});

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  List<Object> get props => [errorMessage];

}



