import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/services/data/models/addNewServiceModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';

abstract class ServicesEvent extends Equatable {
  const ServicesEvent();
}

class GetServices extends ServicesEvent {
  final String section_id;

  GetServices({
    required this.section_id,
  });

  @override
  List<Object> get props => [section_id];
}

class GetServiceProviderServices extends ServicesEvent {
  final String token;

  GetServiceProviderServices({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}

class GetServicesByName extends ServicesEvent {
  final String section_id;
  final String serviceName;

  GetServicesByName({required this.section_id, required this.serviceName});

  @override
  List<Object> get props => [section_id, serviceName];
}

class GetServicesByDate extends ServicesEvent {
  final String section_id;
  final String date;

  GetServicesByDate({required this.section_id, required this.date});

  @override
  List<Object> get props => [section_id, date];
}

class GetServicesByPrice extends ServicesEvent {
  final String section_id;
  final String priceFrom;
  final String priceTo;

  GetServicesByPrice(
      {required this.section_id,
      required this.priceFrom,
      required this.priceTo});

  @override
  List<Object> get props => [section_id, priceFrom, priceFrom];
}

class GetServicesByScale extends ServicesEvent {
  final String section_id;
  final String scaleFrom;
  final String scaleTo;

  GetServicesByScale(
      {required this.section_id,
      required this.scaleFrom,
      required this.scaleTo});

  @override
  List<Object> get props => [section_id, scaleFrom, scaleFrom];
}

class CacheService extends ServicesEvent {
  ServicesModel servicesModel;

  CacheService({required this.servicesModel});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddNewService extends ServicesEvent {
  AddNewServiceModel addNewServiceModel;

  AddNewService({
    required this.addNewServiceModel,
  });

  @override
  List<Object> get props => [addNewServiceModel];
}

class EditAllDetailsOfService extends ServicesEvent {
  ServicesModel servicesModel;

  EditAllDetailsOfService({
    required this.servicesModel,
  });
  @override
  List<Object?> get props => [servicesModel];
}

class AddNewServiceImage extends ServicesEvent {
  String id, image;

  AddNewServiceImage({required this.id, required this.image});

  @override
  List<Object?> get props => [id, image];
}

class AddToFavorite extends ServicesEvent {
  ServicesModel servicesModel;
  final int customerId;

  AddToFavorite({required this.servicesModel, required this.customerId});
  @override
  List<Object?> get props => [servicesModel];
}

class RemoveService extends ServicesEvent {
  final String id;
  final String token;

  RemoveService({
    required this.token,
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
