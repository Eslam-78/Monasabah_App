import 'dart:developer';

import 'package:dartz/dartz.dart';


import 'error/exceptions.dart';
import 'error/failures.dart';

typedef Future<dynamic> GetDataFunction();
typedef dynamic GetCacheDataFunction();

class Repository {
  Future<Either<Failure, dynamic>> sendRequest({

    GetDataFunction? remoteFunction,
    GetCacheDataFunction? getCacheDataFunction,
    required Future<bool> checkConnection,
  }) async {
    log('send request running');


    if (await checkConnection) {
      log('check connection ');
      try {
        log('try from repositories');

        final remoteData = await remoteFunction!();
        log('the data from repositories is $remoteData');
        return Right(remoteData);


      } on InvalidException {
        return Left(InvalidFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on EmptyException {
        return Left(NotFoundFailure());
      } on UniqueException {
        return Left(UniqueFailure());
      } on ExpireException {
        return Left(ExpireFailure());
      } on UserExistsException {
        return Left(UserExistsFailure());
      } on ServerException {
        return Left(ServerFailure());
      } on ReceiveException {
        return Left(ReceiveFailure());
      } on BlockedException {

        return Left(BlockedFailure());
      } on UnauthenticatedException{
        return Left(UnauthenticatedFailure());
      } catch (Exception) {
        log('exception is  ${Exception}');
        return Left(ReceiveFailure());///here is the error
      }
    } else {
      if (getCacheDataFunction == null) {
        return Left(ConnectionFailure());
      }

      try {
        final localData = getCacheDataFunction();
        return Right(localData);
      } on CacheException {
        return Left(CacheFailure());
      } on EmptyException {
        return Left(NotFoundFailure());
      } catch (Exception) {
        print(Exception);
        return Left(ConnectionFailure());
      }
    }
  }
}
