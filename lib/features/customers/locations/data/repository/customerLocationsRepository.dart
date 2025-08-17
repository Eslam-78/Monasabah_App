import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/dataProviders/network/Network_info.dart';
import 'package:monasbah/dataProviders/network/data_source_url.dart';
import 'package:monasbah/dataProviders/remote_data_provider.dart';
import 'package:monasbah/dataProviders/repository.dart';
import 'package:monasbah/features/customers/cart/data/models/customerLocationsModel.dart';

class CustomerLocationsRepository extends Repository{
  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final LocalDataProvider localDataProvider; //get the data from the local cache
  final NetworkInfo networkInfo; //check if the device is connected to internet

  CustomerLocationsRepository({
    required this.remoteDataProvider,
    required this.localDataProvider,
    required this.networkInfo,
  });

  Future<Either<Failure, dynamic>> getCustomerLocations({required String api_token}) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.customerLocations,
            retrievedDataType: CustomerLocationsModel.init(),
            returnType:List,
            body: {
              'api_token':api_token
            });

          localDataProvider.cacheData(key: 'CACHED_CUSTOMER_ADDRESSES', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_CUSTOMER_ADDRESSES',
              retrievedDataType: CustomerLocationsModel.init(),
              returnType: List
          );
        });
  }


  Future<Either<Failure, dynamic>> addNewCustomerAddress({required String api_token,required String locationName,
  required String description,required String lat,required String long})async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.addNewCustomerLocation,
            retrievedDataType: String,
            returnType: String,
            body: {
              'api_token':api_token,
              'locationName':locationName,
              'description':description,
              'lat':lat,
              'long':long
            });
        return remoteData;
      },
    );
  }


  Future<Either<Failure, dynamic>> removeCustomerAddress({required String token,required String id})async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.removeCustomerLocations,
            retrievedDataType: String,
            returnType: String,
            body: {
              'api_token':token,
              'id':id
            });
        return remoteData;
      },
    );
  }







}