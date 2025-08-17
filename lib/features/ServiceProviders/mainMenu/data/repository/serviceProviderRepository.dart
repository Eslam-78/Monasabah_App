import 'dart:developer';
import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/dataProviders/network/Network_info.dart';
import 'package:monasbah/dataProviders/network/data_source_url.dart';
import 'package:monasbah/dataProviders/remote_data_provider.dart';
import 'package:monasbah/dataProviders/repository.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/data/model/citiesModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';
class ServiceProviderRepository extends Repository{

  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final LocalDataProvider localDataProvider; //get the data from the local cache
  final NetworkInfo networkInfo; //check if the device is connected to internet

  ServiceProviderRepository({
    required this.remoteDataProvider,
    required this.localDataProvider,
    required this.networkInfo,
  });


  Future<Either<Failure, dynamic>> getCities({required token}) async {
    log('get main menu data running ');
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.getCities,
            retrievedDataType: CitiesModel.init(),
            returnType:List,
            body: {
              'api_token': token,
            },
          );

          localDataProvider.cacheData(key: 'CACHED_CITIES', data: remoteData);
          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_CITIES',
              retrievedDataType: CitiesModel.init(),
              returnType: List
          );
        });

  }




}