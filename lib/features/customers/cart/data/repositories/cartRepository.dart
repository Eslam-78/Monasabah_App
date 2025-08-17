import 'package:dartz/dartz.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/dataProviders/network/Network_info.dart';
import 'package:monasbah/dataProviders/remote_data_provider.dart';
import 'package:monasbah/dataProviders/repository.dart';
import 'package:monasbah/features/customers/cart/data/models/cartModel.dart';

class CartRepository extends Repository{
  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final LocalDataProvider localDataProvider; //get the data from the local cache
  final NetworkInfo networkInfo; //check if the device is connected to internet

  CartRepository({
    required this.remoteDataProvider,
    required this.localDataProvider,
    required this.networkInfo,
  });


  Future<Either<Failure, dynamic>> getCart() async {
    return await sendRequest(
      checkConnection: Future.value(false),
      getCacheDataFunction: () {
        final remoteData = localDataProvider.getCachedData(
          key: 'CACHED_CART',
          returnType: List,
          retrievedDataType: CartModel.init(),
        );
        print('local date is $remoteData');
        return remoteData;
      },
    );
  }



  Future<Either<Failure, dynamic>> updateCart({required List<dynamic> cart}) async {
    return await sendRequest(
      checkConnection: Future.value(false),
      getCacheDataFunction: () {
        final remoteData = localDataProvider.cacheData(
          key: 'CACHED_CART',
          data: cart,
        );
        return remoteData;
      },
    );
  }

  Future<bool> clearCart() async {
    return await localDataProvider.clearCache(key: 'CACHED_CART');
  }




}