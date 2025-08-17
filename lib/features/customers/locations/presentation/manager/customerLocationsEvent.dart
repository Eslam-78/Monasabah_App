import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/cart/data/models/customerLocationsModel.dart';

abstract class CustomerLocationsEvent extends Equatable{
  const CustomerLocationsEvent();
}

class GetCustomerLocations extends CustomerLocationsEvent {

  final String api_token;

  GetCustomerLocations({
    required this.api_token,
  });

  @override
  List<Object> get props => [api_token];
}

class AddNewCustomerLocation extends CustomerLocationsEvent {
  final String api_token,locationName,description;
  final String lat,long;

  AddNewCustomerLocation({
    required this.api_token,required this.locationName,required this.description,required this.lat,required this.long,
  });

  @override
  List<Object> get props => [api_token,locationName,description,lat,long];
}

class RemoveCustomerLocation extends CustomerLocationsEvent{
  String token;
  String id;

  RemoveCustomerLocation({required this.token,required this.id});

  @override
  List<Object?> get props => [token,id];


}
