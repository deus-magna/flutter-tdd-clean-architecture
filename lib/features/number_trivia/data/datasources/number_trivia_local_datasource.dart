import 'package:trivia_number/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {

  /// Gets teh cached [NumberTriviaModel] wich was gotten the last time
  /// the user had an internet connection.
  /// 
  /// Throws [CacheDataException] if no cached data is present
  Future<NumberTriviaModel> getLastNumberTrivia();
  
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache); 
  
}