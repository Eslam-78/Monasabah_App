import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/services/data/models/serviceRatingModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesImageModel.dart';

abstract class ServicesDetailsState extends Equatable{
  const ServicesDetailsState();
}

///common
class ServicesDetailsInitial extends ServicesDetailsState{
  @override
  List<Object?> get props => [];

}

class ServicesDetailsLoading extends ServicesDetailsState{
  @override
  List<Object?> get props => [];

}

class ServicesDetailsError extends ServicesDetailsState {

  final String errorMessage;
  ServicesDetailsError({required this.errorMessage});

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  List<Object> get props => [errorMessage];

}

///Services Images
class GetServicesImagesLoaded extends ServicesDetailsState{
  final List<ServicesImagesModel>  servicesImagesModel;

  GetServicesImagesLoaded({required this.servicesImagesModel});

  @override
  List<Object> get props => [servicesImagesModel];
}
///services raiting
class GetServiceRateLoaded extends ServicesDetailsState{
  final List<ServiceRatingModel> serviceRatingModel;

  GetServiceRateLoaded({required this.serviceRatingModel});

  @override
  List<Object?> get props => [serviceRatingModel];

}

class GetCustomerServiceRateLoaded extends ServicesDetailsState{
  final String rate;

  GetCustomerServiceRateLoaded({required this.rate});

  @override
  List<Object?> get props => [rate];

}

class AddCustomerServiceRate extends ServicesDetailsState{

  String message;

  AddCustomerServiceRate({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];

}

class EditServiceDetailsDone extends ServicesDetailsState{
  String message;

  EditServiceDetailsDone({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];

}


