import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:monasbah/dataProviders/error/failures.dart';

import 'package:monasbah/features/customers/services/data/repositories/ReservationsReportRepository.dart';

import 'ReservationsReportEvent.dart';
import 'ReservationsReportState.dart';

class ReservationsReportBloc
    extends Bloc<ReservationsReportEvent, ReservationsReportState> {
  final ReservationsReportRepository repository;

  ReservationsReportBloc({required this.repository})
      : super(ReservationsReportInitial());

  @override
  Stream<ReservationsReportState> mapEventToState(
      ReservationsReportEvent event) async* {
    if (event is GetReservationsReport) {
      yield ReservationsReportLoading();
      final failureOrData =
          await repository.getReservationReport(service_id: event.service_id);
      yield* failureOrData.fold(
        (failure) async* {
          log('yield is error');
          yield ReservationsReportError(message: mapFailureToMessage(failure));
        },
        (data) async* {
          log('yield is loaded');
          yield ReservationsReportLoaded(reservationReportModel: data);
        },
      );
    }
  }
}
