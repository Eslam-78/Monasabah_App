import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/dataProviders/network/Network_info.dart';
import 'package:monasbah/dataProviders/network/data_source_url.dart';
import 'package:monasbah/dataProviders/remote_data_provider.dart';
import 'package:monasbah/dataProviders/repository.dart';
import 'package:monasbah/features/customers/adds/data/model/addsModel.dart';
import 'package:monasbah/features/customers/home/data/models/categories/categoriesModel.dart';
import 'package:monasbah/features/customers/home/data/models/categories/productsModel.dart';

class AddsRepository extends Repository{
  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final LocalDataProvider localDataProvider; //get the data from the local cache
  final NetworkInfo networkInfo; //check if the device is connected to internet

  AddsRepository({
    required this.remoteDataProvider,
    required this.localDataProvider,
    required this.networkInfo,
  });

  Future<Either<Failure, dynamic>> getAllAdds() async {
    log('get main menu data running ');
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.mainMenuAdds,
            retrievedDataType: AddsModel.init(),
            returnType:List,
            body: {}
          );

          localDataProvider.cacheData(key: 'CACHED_ALL_ADDS', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_ALL_ADDS',
              retrievedDataType: AddsModel.init(),
              returnType: List
          );
        });

  }

  Future<Either<Failure, dynamic>> getAddsOfSection({required section_id}) async {
    log('get main menu data running ');
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.sectionsAdds,
            retrievedDataType: AddsModel.init(),
            returnType:List,
            body: {
              'section_id': section_id,
            },
          );

          localDataProvider.cacheData(key: 'CACHED_ADDS_OF_SECTION', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_ADDS_OF_SECTION',
              retrievedDataType: AddsModel.init(),
              returnType: List
          );
        });

  }



}