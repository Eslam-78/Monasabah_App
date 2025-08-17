import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/dataProviders/network/Network_info.dart';
import 'package:monasbah/dataProviders/network/data_source_url.dart';
import 'package:monasbah/dataProviders/remote_data_provider.dart';
import 'package:monasbah/dataProviders/repository.dart';
import 'package:monasbah/features/customers/services/data/models/servicePreviewsModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesImageModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';

class ServicesPreviewsRepository extends Repository {
  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final LocalDataProvider localDataProvider; //get the data from the local cache
  final NetworkInfo networkInfo; //check if the device is connected to internet

  ServicesPreviewsRepository({
    required this.remoteDataProvider,
    required this.localDataProvider,
    required this.networkInfo,
  });

  Future<Either<Failure, dynamic>> addServicePreview(
      {required String service_id, api_token, preview}) async {
    log('get main menu data running ');
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.addServicePreview,
              retrievedDataType: String,
              returnType: String,
              body: {
                'service_id': service_id,
                'api_token': api_token,
                'preview': preview
              });

          return remoteData;
        });
  }

  Future<Either<Failure, dynamic>> deleteServicePreview({
    required String service_id,
    required String api_token,
  }) async {
    log('delete service preview running');
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        final remoteData = await remoteDataProvider.sendData(
          url: DataSourceURL.deleteServicePreview, // تأكد إن الرابط موجود عندك
          retrievedDataType: String,
          returnType: String,
          body: {
            'service_id': service_id,
            'api_token': api_token,
          },
        );

        return remoteData;
      },
    );
  }

  Future<Either<Failure, dynamic>> getServicesPreview(
      {required String service_id}) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.getServicePreviews,
              retrievedDataType: ServicePreviewsModel.init(),
              returnType: List,
              body: {
                'service_id': service_id,
              });

          localDataProvider.cacheData(
              key: 'CACHED_SERVICE_PREVIEW$service_id', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_SERVICE_PREVIEW$service_id',
              retrievedDataType: ServicePreviewsModel.init(),
              returnType: List);
        });
  }
}
