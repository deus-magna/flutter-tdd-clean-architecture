import 'package:dartz/dartz.dart';
import 'package:trivia_number/core/error/failures.dart';
import 'package:trivia_number/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
