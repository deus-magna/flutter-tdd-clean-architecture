import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia_number/core/error/failures.dart';
import 'package:trivia_number/core/usecases/usecase.dart';
import 'package:trivia_number/core/util/input_converter.dart';
import 'package:trivia_number/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_number/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_number/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:trivia_number/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() =>   when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
    test(
      'Should call the ImputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );
    test(
      'Should emit [Error] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // assert later
        final expected = [
          //Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
    test(
      'Should get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((realInvocation) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any)); 
        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );
    test(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
      setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((realInvocation) async => Right(tNumberTrivia)); 
        // assert later
        final expected = [
          //Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        // act
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
    test(
      'Should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
      setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((realInvocation) async => Left(ServerFailure())); 
        // assert later
        final expected = [
          //Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        // act
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      '''Should emit [Loading, Error] with a proper 
      message for the error when getting data fails''',
      () async {
        // arrange
      setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((realInvocation) async => Left(CacheFailure())); 
        // assert later
        final expected = [
          //Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        // act
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test(
      'Should get data from the random use case',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
        .thenAnswer((realInvocation) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any)); 
        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );
    test(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
        .thenAnswer((realInvocation) async => Right(tNumberTrivia)); 
        // assert later
        final expected = [
          //Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        // act
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
        bloc.add(GetTriviaForRandomNumber());
      },
    );
    test(
      'Should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
        .thenAnswer((realInvocation) async => Left(ServerFailure())); 
        // assert later
        final expected = [
          //Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        // act
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      '''Should emit [Loading, Error] with a proper 
      message for the error when getting data fails''',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
        .thenAnswer((realInvocation) async => Left(CacheFailure())); 
        // assert later
        final expected = [
          //Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        // act
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });

  
}