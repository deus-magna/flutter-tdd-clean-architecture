import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia_number/core/usecases/usecase.dart';
import 'package:trivia_number/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_number/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_number/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

    void main() {

      GetRandomNumberTrivia usecase;
      MockNumberTriviaRepository mockNumberTriviaRepository;

      setUp(() {
        mockNumberTriviaRepository = MockNumberTriviaRepository();
        usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
      });

      final testNumberTrivia = NumberTrivia(text: 'test', number: 1);

      test('should get random trivia from the repository', 
      () async {
        // arrange
        when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(testNumberTrivia));

        // act
        final result = await usecase(NoParams());

        // assert
        expect(result, Right(testNumberTrivia));
        verify(mockNumberTriviaRepository.getRandomNumberTrivia());
        verifyNoMoreInteractions(mockNumberTriviaRepository);
        
      });
      
    }
