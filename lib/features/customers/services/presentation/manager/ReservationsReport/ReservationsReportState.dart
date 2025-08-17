// ReservationsReportState.dart
import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/services/data/models/ReservationsReportModel.dart';

abstract class ReservationsReportState extends Equatable {
  const ReservationsReportState();

  ///common
}

class ReservationsReportInitial extends ReservationsReportState {
  @override
  List<Object> get props => [];
}

class ReservationsReportLoading extends ReservationsReportState {
  @override
  List<Object> get props => [];

}

class ReservationsReportLoaded extends ReservationsReportState {
  final List<ReservationReportModel> reservationReportModel;

  ReservationsReportLoaded({required this.reservationReportModel});

  @override
  List<Object> get props => [ReservationReportModel];
}

class ReservationsReportError extends ReservationsReportState {
  final String message;

  ReservationsReportError({required this.message});

  @override
  List<Object> get props => [message];
}
