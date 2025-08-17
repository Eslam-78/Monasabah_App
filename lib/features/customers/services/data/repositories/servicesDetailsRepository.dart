import 'package:dartz/dartz.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/dataProviders/network/Network_info.dart';
import 'package:monasbah/dataProviders/network/data_source_url.dart';
import 'package:monasbah/dataProviders/remote_data_provider.dart';
import 'package:monasbah/dataProviders/repository.dart';
import 'package:monasbah/features/customers/services/data/models/serviceEditingModel.dart';
import 'package:monasbah/features/customers/services/data/models/serviceRatingModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesImageModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';


class ServicesDetailsRepository extends Repository{
  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final LocalDataProvider localDataProvider; //get the data from the local cache
  final NetworkInfo networkInfo; //check if the device is connected to internet

  ServicesDetailsRepository({
    required this.remoteDataProvider,
    required this.localDataProvider,
    required this.networkInfo,
  });

  Future<Either<Failure, dynamic>> getServicesImages({required String service_id}) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
              url: DataSourceURL.getServiceImages,
              retrievedDataType: ServicesImagesModel.init(),
              returnType:List,
              body: {
                'service_id':service_id,
              });

          localDataProvider.cacheData(key: 'CACHED_SERVICE_IMAGES$service_id', data: remoteData);

          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_SERVICE_IMAGES',
              retrievedDataType: ServicesImagesModel.init(),
              returnType: List
          );
        });
  }

  Future<Either<Failure, dynamic>> addCustomerServicesRate({required String token,required String service_id,required String rate}) async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.addCustomerRate,
            retrievedDataType: String,
            returnType: String,
            body: {
              'api_token':token,
              'service_id':service_id,
              'rate':rate
            }
        );

        return remoteData;
      },
    );

  }


  Future<Either<Failure, dynamic>> getServicesRating({required String service_id}) async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.getServiceRating,
            retrievedDataType: ServiceRatingModel.init(),
            returnType: List,
            body: {
              'service_id':service_id
            });
        localDataProvider.cacheData(key: 'CACHED_SERVICE_RATING$service_id', data: remoteData);

        return remoteData;
      },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_SERVICE_RATING$service_id',
              retrievedDataType: ServiceRatingModel.init(),
              returnType: List
          );
        });

  }

  Future<Either<Failure, dynamic>> getCustomerServiceRating({required String service_id,required String token}) async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.getCustomerServiceImages,
            retrievedDataType: String,
            returnType: String,
            body: {
              'api_token':token,
              'service_id':service_id
            });
        localDataProvider.cacheData(key: 'CACHED_SERVICE_RATING$service_id', data: remoteData);

        return remoteData;
      },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_SERVICE_RATING$service_id',
              retrievedDataType: String,
              returnType: String
          );
        });

  }

  late ServicesModel servicesModel;
  Future<Either<Failure, dynamic>> editServiceDetails({required EditServiceModel editServiceModel}) async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.editServiceDetails,
            retrievedDataType: ServicesModel.init(),
            returnType: List,
            body: editServiceModel.toJson(),
        );

        List<ServicesModel> s=remoteData;
        servicesModel=s[0];

        localDataProvider.cacheData(key: 'CACHED_SERVICE', data: servicesModel);

        return remoteData;
      });


  }


}