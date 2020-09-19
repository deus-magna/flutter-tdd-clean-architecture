import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_number/core/util/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignInt', () {
    test(
      'Should return an integer when the string represents an unsigned integer',
      () async {
        // arrange
        final str = '123';
        // act
        final result = inputConverter.stringToUnsignedInteger(str);
        // assert
        expect(result, Right(123));
      },
    );

    test(
      'Should return a Failure when the string is not an integer',
      () async {
        // arrange
        final str = 'abc';
        // act
        final result = inputConverter.stringToUnsignedInteger(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      'Should return a Failure when the string is a negative integer',
      () async {
        // arrange
        final str = '-123';
        // act
        final result = inputConverter.stringToUnsignedInteger(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}