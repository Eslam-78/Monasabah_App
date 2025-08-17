import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/services/data/models/servicePreviewsModel.dart';

abstract class ServicesReservationsEvent extends Equatable{
  const ServicesReservationsEvent();
}


class GetServiceReservations extends ServicesReservationsEvent {

  final String service_id;
  GetServiceReservations({
    required this.service_id,
  });

  @override
  List<Object> get props => [service_id];
}

class GetHighlightedDates extends ServicesReservationsEvent {

  final String service_id,reserveDate;
  GetHighlightedDates({
    required this.service_id,
    required this.reserveDate
  });

  @override
  List<Object> get props => [service_id,reserveDate];
}

class GetServiceReservationsOfCustomer extends ServicesReservationsEvent {

  final String token;
  GetServiceReservationsOfCustomer({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}

class AddServiceReservation extends ServicesReservationsEvent{
  final String service_id,reserveDate,service_reservation_price;
  dynamic ?api_token;
  AddServiceReservation({
    required this.service_id,
    required this.api_token,
    required this.reserveDate,
    required this.service_reservation_price,
  });

  @override
  List<Object> get props => [service_id,api_token,reserveDate];
}

class BlockDateReservation extends ServicesReservationsEvent{
  final String service_id,reserveDate,service_reservation_price,blockUnBlock;

  BlockDateReservation({
    required this.service_id,
    required this.reserveDate,
    required this.service_reservation_price,
    required this.blockUnBlock,

  });

  @override
  List<Object> get props => [service_id,reserveDate,service_reservation_price,blockUnBlock];
}


class AcceptReservation extends ServicesReservationsEvent{
  String service_id,customer_id,reserveDate;

  AcceptReservation({required this.service_id,required this.customer_id,required this.reserveDate});

  @override
  List<Object?> get props => [service_id,customer_id,reserveDate];

}

class DeclineReservation extends ServicesReservationsEvent{
  String token,id;

  DeclineReservation({required this.token,required this.id});

  @override
  List<Object?> get props => [token,id];

}
