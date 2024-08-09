import 'package:equatable/equatable.dart';

import '../services/movie_model.dart';
abstract class MovieEvent extends Equatable{
  List<Object?> get props => [];
}

class FetchMovies extends MovieEvent{
  final int page;
  FetchMovies({this.page = 1});
  @override
  List<Object?> get props => [page];
}
class SearchMovies extends MovieEvent{

  final String query;
  SearchMovies( this.query);
  @override
  List<Object?> get props => [query];
}