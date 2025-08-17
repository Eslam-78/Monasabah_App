import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/dataProviders/network/Network_info.dart';
import 'package:monasbah/dataProviders/remote_data_provider.dart';
import 'package:monasbah/dataProviders/repository.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';

class FavoriteRepository extends Repository {
  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final LocalDataProvider localDataProvider; //get the data from the local cache
  final NetworkInfo networkInfo; //check if the device is connected to internet

  FavoriteRepository({
    required this.remoteDataProvider,
    required this.localDataProvider,
    required this.networkInfo,
  });

  Future<Either<Failure, dynamic>> getFavorite(
      {required int customerId}) async {
    final String cacheKey = 'CACHED_FAVORITE_$customerId';

    return await sendRequest(
      checkConnection: Future.value(false),
      getCacheDataFunction: () {
        final remoteData = localDataProvider.getCachedData(
          key: cacheKey,
          returnType: List,
          retrievedDataType: ServicesModel.init(),
        );
        print('local data for customer $customerId is $remoteData');
        return remoteData;
      },
    );
  }

  Future<Either<Failure, dynamic>> updateFavorite({
    required List<dynamic> Favorite,
    required int customerId,
  }) async {
    final String cacheKey = 'CACHED_FAVORITE_$customerId';

    return await sendRequest(
      checkConnection: Future.value(false),
      getCacheDataFunction: () {
        final remoteData = localDataProvider.cacheData(
          key: cacheKey,
          data: Favorite,
        );
        return remoteData;
      },
    );
  }

  Future<bool> clearFavorite({required int customerId}) async {
    final String cacheKey = 'CACHED_FAVORITE_$customerId';
    return await localDataProvider.clearCache(key: cacheKey);
  }
}
