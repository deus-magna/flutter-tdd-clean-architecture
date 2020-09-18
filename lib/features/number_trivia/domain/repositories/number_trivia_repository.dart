import 'package:dartz/dartz.dart';
import 'package:trivia_number/core/error/failures.dart';
import 'package:trivia_number/features/number_trivia/domain/entities/number_trivia.dart';

/// Un repositorio es un contrato que nos permite colocar
/// reglas de como se deben obtener los datos desde los resourses para
/// despues convertirlos en los entities.
/// Solo son reglas, no mas.
abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
