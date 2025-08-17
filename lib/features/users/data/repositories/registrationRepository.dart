import 'package:dartz/dartz.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/dataProviders/network/Network_info.dart';
import 'package:monasbah/dataProviders/network/data_source_url.dart';
import 'package:monasbah/dataProviders/remote_data_provider.dart';
import 'package:monasbah/dataProviders/repository.dart';
import 'package:monasbah/features/users/data/models/SignUpModel.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';
import 'package:monasbah/features/users/data/models/loginModel.dart';
import 'package:monasbah/features/users/data/models/serviceProviderModel.dart';

class RegistrationRepository extends Repository{
  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final LocalDataProvider localDataProvider; //get the data from the local cache
  final NetworkInfo networkInfo; //check if the device is connected to internet

  RegistrationRepository({
    required this.remoteDataProvider,
    required this.localDataProvider,
    required this.networkInfo,
  });

  late  CustomerModel customer;
  late ServiceProviderModel serviceProviderModel;

  Future<Either<Failure, dynamic>> signup({required SignUpModel signUpModel})async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.signup,
            retrievedDataType: String,
            returnType: String,
            body:signUpModel.toJson()
        );

        return remoteData;
      },
    );
  }

  Future<Either<Failure, dynamic>> sendLoginRequest({required LoginModel loginModel})async {
    print('send login request user Brand is ${loginModel.userBrand}');


    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        final remoteData = await remoteDataProvider.sendData(
          url: DataSourceURL.login,
          retrievedDataType:loginModel.userBrand=='customer'? CustomerModel.init():ServiceProviderModel.init(),
          body:loginModel.toJson(),
        );


        if(loginModel.userBrand=='customer'){
          customer=remoteData;
        }else{
           serviceProviderModel=remoteData;
        }

        localDataProvider.cacheData(key:loginModel.userBrand=='customer'? 'CUSTOMER_USER':'SERVICE_PROVIDER_USER',
            data:loginModel.userBrand=='customer'? customer.toJson():serviceProviderModel.toJson());

        return remoteData;
      },
    );
  }

  Future<Either<Failure, dynamic>> sendConfirmCode({required String email,userBrand})async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.sendConfirmCode,
            retrievedDataType: String,
            returnType: String,
            body: {
              'email':email,
              'userBrand':userBrand
            });

        return remoteData;
      },
    );
  }

  Future<Either<Failure, dynamic>> checkConfirmCode({required String email,confirmCode,userBrand})async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.checkConfirmCode,
            retrievedDataType: String,
            returnType: String,
            body: {
              'email':email,
              'confirmCode':confirmCode,
              'userBrand':userBrand
            });

        return remoteData;
      },
    );
  }

  Future<Either<Failure, dynamic>> editPassword({required String email,password,userBrand})async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        final remoteData = await remoteDataProvider.sendData(
          url: DataSourceURL.editPassword,
          retrievedDataType: String,
          returnType: String,
          body: {
            'email':email,
            'password':password,
            'userBrand':userBrand
          });

        return remoteData;
      },
    );
  }

  Future<Either<Failure, dynamic>> logout({required String token})async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        final remoteData = await remoteDataProvider.sendData(
          url: DataSourceURL.logout,
          retrievedDataType: String,
          returnType: String,
          body: {
            'api_token':token,
          });

        return remoteData;
      },
    );
  }


}