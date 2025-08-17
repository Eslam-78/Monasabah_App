import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/dataProviders/network/Network_info.dart';
import 'package:monasbah/dataProviders/network/data_source_url.dart';
import 'package:monasbah/dataProviders/remote_data_provider.dart';
import 'package:monasbah/dataProviders/repository.dart';
import 'package:monasbah/features/customers/cart/data/models/newOrderModel.dart';
import 'package:monasbah/features/customers/home/data/models/MyOrders/MyOrdersModel.dart';
class MyOrdersRepository extends Repository{
  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final LocalDataProvider localDataProvider; //get the data from the local cache
  final NetworkInfo networkInfo; //check if the device is connected to internet

  MyOrdersRepository({
    required this.remoteDataProvider,
    required this.localDataProvider,
    required this.networkInfo,
  });


  Future<Either<Failure, dynamic>> newOrder({required NewOrderModel newOrderModel}) async {
    log('get main menu data running ');
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.addOrder,
            retrievedDataType: String,
            returnType:String,
            body: newOrderModel.toJson()
          );


          return remoteData;
        });

  }

  Future<Either<Failure, dynamic>> getMyOrders({required token}) async {
    log('get main menu data running ');
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.getCustomerOrders,
            retrievedDataType: MyOrdersModel.init(),
            returnType:List,
            body: {
              'api_token': token,
            },
          );

          localDataProvider.cacheData(key: 'CACHED_MY_ORDERS', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_MY_ORDERS',
              retrievedDataType: MyOrdersModel.init(),
              returnType: List
          );
        });

  }

}