import 'package:flutter/material.dart';
import 'package:trivia_number/core/error/exceptions.dart';
import 'package:trivia_number/core/platform/network_info.dart';
import 'package:trivia_number/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:trivia_number/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:trivia_number/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_number/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:trivia_number/features/number_trivia/domain/repositories/number_trivia_repository.dart';

/// Los typedef nos sirven para poder reemplazar
/// el tipo de una funcion que sea muy largo
/// por una palabra mas corecta.
typedef Future<NumberTrivia> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    return await _getTrivia(() => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  /// High Order Functions
  /// Basicamente es pasar una funcion dentro de otra funcion 
  /// para despues usarla adentro y que regrese un valor.
  Future<Either<Failure, NumberTrivia>> _getTrivia(
    // Future<NumberTrivia> Function() getConcreteOrRandom <- Asi se hace sin typedef
    _ConcreteOrRandomChooser getConcreteOrRandom
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
