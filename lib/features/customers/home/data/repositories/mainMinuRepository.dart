import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/dataProviders/network/Network_info.dart';
import 'package:monasbah/dataProviders/network/data_source_url.dart';
import 'package:monasbah/dataProviders/remote_data_provider.dart';
import 'package:monasbah/dataProviders/repository.dart';
import 'package:monasbah/features/customers/home/data/models/categories/categoriesModel.dart';
import 'package:monasbah/features/customers/home/data/models/mainMenuSectionsModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';

class MainMenuRepository extends Repository{

  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final LocalDataProvider localDataProvider; //get the data from the local cache
  final NetworkInfo networkInfo; //check if the device is connected to internet

  MainMenuRepository({
    required this.remoteDataProvider,
    required this.localDataProvider,
    required this.networkInfo,
  });


  Future<Either<Failure, dynamic>> getMainMenuSections({required token}) async {
    log('get main menu data running ');
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.mainMenuSections,
            retrievedDataType: MainMenuSectionsModel.init(),
            returnType:List,
            body: {
              'api_token': token,
            },
          );

          localDataProvider.cacheData(key: 'CACHED_MAIN_MENU_SECTIONS', data: remoteData);
          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_MAIN_MENU_SECTIONS',
              retrievedDataType: MainMenuSectionsModel.init(),
              returnType: List
          );
        });

  }

  Future<Either<Failure, dynamic>> getMostBookedServices({required token}) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.mainMenuMostBookedServices,
              retrievedDataType: ServicesModel.init(),
              returnType:List,
              body: {
                'api_token':token
              });

          localDataProvider.cacheData(key: 'CACHED_MOST_BOOKED_SERVICES', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_MOST_BOOKED_SERVICES',
              retrievedDataType: ServicesModel.init(),
              returnType: List
          );
        });
  }

  Future<Either<Failure, dynamic>> getMostRatedServices({required token}) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.mainMenuMostRatedServices,
              retrievedDataType: ServicesModel.init(),
              returnType:List,
              body: {
                'api_token':token
              });

          localDataProvider.cacheData(key: 'CACHED_MOST_RATED_SERVICES', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_MOST_RATED_SERVICES',
              retrievedDataType: ServicesModel.init(),
              returnType: List
          );
        });
  }



}