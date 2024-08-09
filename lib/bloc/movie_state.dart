import 'package:equatable/equatable.dart';
import 'package:movie_from_api/services/movie_model.dart';

abstract class MovieState extends Equatable {
  const MovieState();
  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}
class MovieLoading extends MovieState {}
class MovieLoaded extends MovieState{
  final  List <MovieModel> movies;
  const  MovieLoaded (this.movies);

}
 class MovieError extends MovieState{
  final String message;
  const MovieError(this.message);
  @override
  List< Object?> get props => [message];
 }
class MovieSearchLoaded extends MovieState {
  final List<MovieModel> movies;

  const MovieSearchLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}


