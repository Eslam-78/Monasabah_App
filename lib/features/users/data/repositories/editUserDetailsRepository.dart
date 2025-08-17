import 'package:dartz/dartz.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/dataProviders/network/Network_info.dart';
import 'package:monasbah/dataProviders/network/data_source_url.dart';
import 'package:monasbah/dataProviders/remote_data_provider.dart';
import 'package:monasbah/dataProviders/repository.dart';
import 'package:monasbah/features/users/data/models/SignUpModel.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';
import 'package:monasbah/features/users/data/models/editUserDetailsModel.dart';
import 'package:monasbah/features/users/data/models/loginModel.dart';
import 'package:monasbah/features/users/data/models/serviceProviderModel.dart';

class EditUserDetailsRepository extends Repository{
  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final LocalDataProvider localDataProvider; //get the data from the local cache
  final NetworkInfo networkInfo; //check if the device is connected to internet

  EditUserDetailsRepository({
    required this.remoteDataProvider,
    required this.localDataProvider,
    required this.networkInfo,
  });

  late  CustomerModel customer;
  late ServiceProviderModel serviceProviderModel;

  Future<Either<Failure, dynamic>> editUserDetails({required EditUserDetailsModel editUserDetailsModel})async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        final remoteData = await remoteDataProvider.sendData(
            url: DataSourceURL.editUserDetails,
            retrievedDataType: editUserDetailsModel.userBrand=='customer'? CustomerModel.init():ServiceProviderModel.init(),
            body:editUserDetailsModel.toJson()
        );

        if(editUserDetailsModel.userBrand=='customer'){
          customer=remoteData;
        }else{
          serviceProviderModel=remoteData;
        }

        localDataProvider.cacheData(key:editUserDetailsModel.userBrand=='customer'? 'CUSTOMER_USER':'SERVICE_PROVIDER_USER', data:editUserDetailsModel.userBrand=='customer'? customer.toJson():serviceProviderModel.toJson());

        return remoteData;
      },
    );
  }



}