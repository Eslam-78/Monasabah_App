import 'package:equatable/equatable.dart';

abstract class ReservationsReportEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetReservationsReport extends ReservationsReportEvent {

  final String service_id;
  GetReservationsReport({
    required this.service_id,
  });

  @override
  List<Object> get props => [service_id];
}
