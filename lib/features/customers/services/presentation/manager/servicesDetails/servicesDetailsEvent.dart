import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/services/data/models/serviceEditingModel.dart';

abstract class ServicesDetailsEvent extends Equatable{
  const ServicesDetailsEvent();
}


class GetServiceImages extends ServicesDetailsEvent {

  final String service_id;
  GetServiceImages({
    required this.service_id,
  });

  @override
  List<Object> get props => [service_id];
}


class AddCustomerServicesRate extends ServicesDetailsEvent{
  String token,service_id,rate;

  AddCustomerServicesRate({required this.token,required this.service_id,required this.rate});

  @override
  List<Object?> get props => [token,service_id,rate];
}

class GetServicesRating extends ServicesDetailsEvent{
  final String service_id;


  GetServicesRating({required this.service_id});

  @override
  List<Object?> get props => [service_id];
}

class GetCustomerServiceRating extends ServicesDetailsEvent{
  String token,service_id;

  GetCustomerServiceRating({required this.service_id,required this.token});

  @override
  List<Object?> get props => [token,service_id];

}

class EditServiceDetails extends ServicesDetailsEvent{

  final EditServiceModel editServiceModel;

  EditServiceDetails({required this.editServiceModel});

  @override
  // TODO: implement props
  List<Object?> get props => [editServiceModel];


}