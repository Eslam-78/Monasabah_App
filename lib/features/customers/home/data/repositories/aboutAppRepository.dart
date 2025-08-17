import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/dataProviders/network/Network_info.dart';
import 'package:monasbah/dataProviders/network/data_source_url.dart';
import 'package:monasbah/dataProviders/remote_data_provider.dart';
import 'package:monasbah/dataProviders/repository.dart';
import 'package:monasbah/features/customers/home/data/models/aboutApp/appDetailsModel.dart';
import 'package:monasbah/features/customers/home/data/models/aboutApp/socialMediaAccountsModel.dart';


class AboutAppRepository extends Repository{

  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final LocalDataProvider localDataProvider; //get the data from the local cache
  final NetworkInfo networkInfo; //check if the device is connected to internet

  AboutAppRepository({
    required this.remoteDataProvider,
    required this.localDataProvider,
    required this.networkInfo,
  });


  Future<Either<Failure, dynamic>> getAboutAppDetails() async {
    log('get main menu data running ');
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.appDetails,
            retrievedDataType: AboutAppModel.init(),
            returnType:List,
            body: {},
          );

          localDataProvider.cacheData(key: 'CACHED_ABOUT_APP_DETAILS', data: remoteData);
          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_ABOUT_APP_DETAILS',
              retrievedDataType: AboutAppModel.init(),
              returnType: List
          );
        });

  }

  Future<Either<Failure, dynamic>> getSocialMediaAccounts() async {
    log('get main menu data running ');
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.appSocialMedia,
            retrievedDataType: SocialMediaAccountsModel.init(),
            returnType:List,
            body: {},
          );

          localDataProvider.cacheData(key: 'CACHED_SOCIAL_MEDIA_ACCOUNTS', data: remoteData);
          return remoteData;
        },
        getCacheDataFunction: () {
          return localDataProvider.getCachedData(
              key: 'CACHED_SOCIAL_MEDIA_ACCOUNTS',
              retrievedDataType: SocialMediaAccountsModel.init(),
              returnType: List
          );
        });

  }




}