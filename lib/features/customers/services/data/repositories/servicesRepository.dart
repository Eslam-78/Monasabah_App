import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/dataProviders/network/Network_info.dart';
import 'package:monasbah/dataProviders/network/data_source_url.dart';
import 'package:monasbah/dataProviders/remote_data_provider.dart';
import 'package:monasbah/dataProviders/repository.dart';
import 'package:monasbah/features/customers/services/data/models/addNewServiceModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicePreviewsModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesImageModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';

class ServicesRepository extends Repository {
  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final LocalDataProvider localDataProvider; //get the data from the local cache
  final NetworkInfo networkInfo; //check if the device is connected to internet

  ServicesRepository({
    required this.remoteDataProvider,
    required this.localDataProvider,
    required this.networkInfo,
  });

  Future<Either<Failure, dynamic>> getServicesOfSection(
      {required String section_id}) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.servicesOfSection,
              retrievedDataType: ServicesModel.init(),
              returnType: List,
              body: {'api_token': 'token', 'section_id': section_id});

          localDataProvider.cacheData(key: 'CACHED_SERVICES', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_SERVICES',
              retrievedDataType: ServicesModel.init(),
              returnType: List);
        });
  }

  Future<Either<Failure, dynamic>> getServiceProviderServices(
      {required String token}) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.servicesOfServiceProvider,
              retrievedDataType: ServicesModel.init(),
              returnType: List,
              body: {
                'api_token': token,
              });

          localDataProvider.cacheData(key: 'CACHED_SERVICES', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_SERVICES',
              retrievedDataType: ServicesModel.init(),
              returnType: List);
        });
  }

  Future<Either<Failure, dynamic>> getServicesByName(
      {required String section_id, required String serviceName}) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.searchServicesByName,
              retrievedDataType: ServicesModel.init(),
              returnType: List,
              body: {'section_id': section_id, 'serviceName': serviceName});

          localDataProvider.cacheData(key: 'CACHED_SERVICES', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_SERVICES',
              retrievedDataType: ServicesModel.init(),
              returnType: List);
        });
  }

  Future<Either<Failure, dynamic>> getServicesByDate(
      {required String section_id, required String date}) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.searchServicesByDate,
              retrievedDataType: ServicesModel.init(),
              returnType: List,
              body: {'section_id': section_id, 'date': date});

          localDataProvider.cacheData(key: 'CACHED_SERVICES', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_SERVICES',
              retrievedDataType: ServicesModel.init(),
              returnType: List);
        });
  }

  Future<Either<Failure, dynamic>> getServicesByPrice(
      {required String section_id,
      required String priceFrom,
      required String priceTo}) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.searchServicesByPrice,
              retrievedDataType: ServicesModel.init(),
              returnType: List,
              body: {
                'section_id': section_id,
                'priceFrom': priceFrom,
                'priceTo': priceTo
              });

          localDataProvider.cacheData(key: 'CACHED_SERVICES', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_SERVICES',
              retrievedDataType: ServicesModel.init(),
              returnType: List);
        });
  }

  Future<Either<Failure, dynamic>> getServicesByScale(
      {required String section_id,
      required String scaleFrom,
      required String scaleTo}) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.searchServicesByScale,
              retrievedDataType: ServicesModel.init(),
              returnType: List,
              body: {
                'section_id': section_id,
                'scaleFrom': scaleFrom,
                'scaleTo': scaleTo
              });

          localDataProvider.cacheData(key: 'CACHED_SERVICES', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_SERVICES',
              retrievedDataType: ServicesModel.init(),
              returnType: List);
        });
  }

  Future<Either<Failure, dynamic>> getServicesImages(
      {required String service_id}) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.searchServicesByScale,
              retrievedDataType: ServicesImagesModel.init(),
              returnType: List,
              body: {
                'service_id': service_id,
              });

          localDataProvider.cacheData(
              key: 'CACHED_SERVICE_IMAGES', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_SERVICE_IMAGES',
              retrievedDataType: ServicesImagesModel.init(),
              returnType: List);
        });
  }

  Future<Either<Failure, dynamic>> addNewService(
      {required AddNewServiceModel addNewServiceModel}) async {
    log('get main menu data running ');
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.addNewService,
              retrievedDataType: String,
              returnType: String,
              body: addNewServiceModel.toJson());

          return remoteData;
        });
  }

  Future<Either<Failure, dynamic>> removeService(
      {required String id, required String token}) async {
    log('delete service running');
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        final remoteData = await remoteDataProvider.sendData(
          url: DataSourceURL.removeService,
          retrievedDataType: String,
          returnType: String,
          body: {
            'id': id,
            'token': token,
          },
        );
        return remoteData;
      },
    );
  }

  Future<Either<Failure, dynamic>> addNewServiceImage(
      {required String id, image}) async {
    log('get main menu data running ');
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.addNewServiceImage,
              retrievedDataType: String,
              returnType: String,
              body: {'id': id, 'image': image});

          return remoteData;
        });
  }

  Future<Either<Failure, dynamic>> addServicePreview(
      {required ServicePreviewsModel servicePreviewModel}) async {
    log('get main menu data running ');
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.addServicePreview,
              retrievedDataType: String,
              returnType: String,
              body: servicePreviewModel.toJson());

          return remoteData;
        });
  }

  Future<Either<Failure, dynamic>> getServicesPreview(
      {required String service_id}) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.searchServicesByScale,
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
              key: 'CACHED_SERVICE_IMAGES$service_id',
              retrievedDataType: ServicePreviewsModel.init(),
              returnType: List);
        });
  }

  cacheService({required ServicesModel servicesModel}) async {
    print(servicesModel.toJson());
    return localDataProvider.cacheData(
        key: 'CACHED_SERVICE', data: servicesModel);
  }

  Future<bool> addToFavorite({
    required ServicesModel servicesModel,
    required int customerId,
  }) async {
    return localDataProvider.addToFavorite(
      data: servicesModel,
      customerId: customerId,
    );
  }
}
