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
import 'package:monasbah/features/customers/services/data/models/servicesReservationsModel.dart';


class ServicesReservationsRepository extends Repository{
  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final LocalDataProvider localDataProvider; //get the data from the local cache
  final NetworkInfo networkInfo; //check if the device is connected to internet

  ServicesReservationsRepository({
    required this.remoteDataProvider,
    required this.localDataProvider,
    required this.networkInfo,
  });


  Future<Either<Failure, dynamic>> addServiceReservation({required String service_id ,api_token,reserveDate,service_reservation_price}) async {
    log('get main menu data running ');
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.addServiceReservation,
            retrievedDataType: String,
              returnType:String,
              body: {
                'service_id':service_id,
                'api_token':api_token,
                'reserveDate':reserveDate,
                'service_reservation_price':service_reservation_price
              });

          return remoteData;
        });

  }


  Future<Either<Failure, dynamic>> blockDateReservation({required String service_id ,reserveDate,service_reservation_price,blockUnBlock}) async {
    log('get main menu data running ');
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.blockDateReservation,
            retrievedDataType: String,
              returnType:String,
              body: {
                'service_id':service_id,
                'reserveDate':reserveDate,
                'service_reservation_price':service_reservation_price,
                'blockUnBlock':blockUnBlock
              });

          return remoteData;
        });

  }


  Future<Either<Failure, dynamic>> acceptReservation({required String service_id,customer_id,reserveDate}) async {
    log('get main menu data running ');
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.acceptReservation,
              retrievedDataType: String,
              returnType:String,
              body: {
                'service_id':service_id,
                'customer_id':customer_id,
                'reserveDate':reserveDate
              });

          return remoteData;
        });

  }

  Future<Either<Failure, dynamic>> declineReservation({required String token,id}) async {
    log('get main menu data running ');
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.declineReservation,
              retrievedDataType: String,
              returnType:String,
              body: {
                'api_token':token,
                'id':id

              });

          return remoteData;
        });

  }

  Future<Either<Failure, dynamic>> getServicesReservations({required String service_id}) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.getServiceReservations,
              retrievedDataType: ServicesReservationsModel.init(),
              returnType:List,
              body: {
                'service_id':service_id,
              });

          localDataProvider.cacheData(key: 'CACHED_SERVICE_RESERVATIONS', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_SERVICE_RESERVATIONS',
              retrievedDataType: ServicesReservationsModel.init(),
              returnType: List
          );
        });
  }

  Future<Either<Failure, dynamic>> getHighlightedDates({required String service_id,reserveDate}) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.getHighlightedDates,
              retrievedDataType: ServicesReservationsModel.init(),
              returnType:List,
              body: {
                'service_id':service_id,
                'reserveDate':reserveDate
              });

          localDataProvider.cacheData(key: 'CACHED_SERVICE_HIGHLIGHT_DATE_DETAILS', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_SERVICE_HIGHLIGHT_DATE_DETAILS',
              retrievedDataType: ServicesReservationsModel.init(),
              returnType: List
          );
        });
  }

  Future<Either<Failure, dynamic>> getServicesReservationsOfCustomer({required String token}) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.getCustomerReservations,
              retrievedDataType: ServicesReservationsModel.init(),
              returnType:List,
              body: {
                'api_token':token,
              });

          localDataProvider.cacheData(key: 'CACHED_SERVICE_RESERVATIONS_OF_CUSTOMER', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_SERVICE_RESERVATIONS_OF_CUSTOMER',
              retrievedDataType: ServicesReservationsModel.init(),
              returnType: List
          );
        });
  }







}