import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/dataProviders/network/Network_info.dart';
import 'package:monasbah/dataProviders/network/data_source_url.dart';
import 'package:monasbah/dataProviders/remote_data_provider.dart';
import 'package:monasbah/dataProviders/repository.dart';
import 'package:monasbah/features/customers/cart/data/models/cartModel.dart';
import 'package:monasbah/features/customers/home/data/models/categories/categoriesModel.dart';
import 'package:monasbah/features/customers/home/data/models/categories/productsModel.dart';

class CategoriesRepository extends Repository{
  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final LocalDataProvider localDataProvider; //get the data from the local cache
  final NetworkInfo networkInfo; //check if the device is connected to internet

  CategoriesRepository({
    required this.remoteDataProvider,
    required this.localDataProvider,
    required this.networkInfo,
  });

  Future<Either<Failure, dynamic>> getCategories({required token}) async {
    log('get main menu data running ');
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.mainMenuCategories,
            retrievedDataType: CategoriesModel.init(),
            returnType:List,
            body: {
              'api_token': token,
            },
          );

          localDataProvider.cacheData(key: 'CACHED_CATEGORIES', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_CATEGORIES',
              retrievedDataType: CategoriesModel.init(),
              returnType: List
          );
        });

  }

  Future<Either<Failure, dynamic>> getProducts({required token,required categoryId}) async {
    log('get main menu data running ');
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.mainMenuSubCategories,
            retrievedDataType: ProductsModel.init(),
            returnType:List,
            body: {
              'api_token': token,
              'category_id':categoryId,
            },
          );

          localDataProvider.cacheData(key: 'CACHED_PRODUCTS$categoryId', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_PRODUCTS$categoryId',
              retrievedDataType: ProductsModel.init(),
              returnType: List
          );
        });

  }


  Future<bool> addToCart(
      { required CartModel cartModel}) async {
    print(cartModel.toJson());
    return  localDataProvider.addToCart(data: cartModel);
  }
}