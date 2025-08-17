import 'package:dartz/dartz.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/dataProviders/network/Network_info.dart';
import 'package:monasbah/dataProviders/network/data_source_url.dart';
import 'package:monasbah/dataProviders/remote_data_provider.dart';
import 'package:monasbah/dataProviders/repository.dart';
import 'package:monasbah/features/customers/services/data/models/ReservationsReportModel.dart';

class ReservationsReportRepository extends Repository {
  final RemoteDataProvider remoteDataProvider;
  final LocalDataProvider localDataProvider;
  final NetworkInfo networkInfo;

  ReservationsReportRepository({
    required this.remoteDataProvider,
    required this.localDataProvider,
    required this.networkInfo,
  });

  Future<Either<Failure, dynamic>> getReservationReport(
      {required String service_id}) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.getReservationsReport,
              retrievedDataType: ReservationReportModel.init(),
              returnType: List,
              body: {
                'service_id': service_id,
              });

          localDataProvider.cacheData(
              key: 'CACHED_SERVICE_RESERVATIONS', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_SERVICE_RESERVATIONS',
              retrievedDataType: ReservationReportModel.init(),
              returnType: List);
        });
  }
}
