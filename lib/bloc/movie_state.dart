import 'package:equatable/equatable.dart';
import 'package:movie_from_api/services/movie_model.dart';

abstract class MovieState extends Equatable {
  final int? currentPage;
  final int? totalPages;
  final String? name;

  const MovieState({
    this.currentPage = 1, // Default to 1
    this.totalPages = 1,  // Default to 1
    this.name,
  });

  @override
  List<Object?> get props => [currentPage, totalPages, name];
}

class MovieInitial extends MovieState {
  const MovieInitial() : super();
}

class MovieLoading extends MovieState {
  final List<MovieModel> movies;

  const MovieLoading({
    required this.movies,
    int? currentPage,
    int? totalPages,
  }) : super(currentPage: currentPage, totalPages: totalPages);

  @override
  List<Object?> get props => [movies, currentPage, totalPages];
}

class MovieLoaded extends MovieState {
  final List<MovieModel> movies;

  const MovieLoaded({
    required this.movies,
    int? currentPage,
    int? totalPages,
  }) : super(currentPage: currentPage, totalPages: totalPages);

  @override
  List<Object?> get props => [movies, currentPage, totalPages];
}

class MovieError extends MovieState {
  final String message;

  const MovieError(
      this.message, {
        int? currentPage,
        int? totalPages,
      }) : super(currentPage: currentPage, totalPages: totalPages);

  @override
  List<Object?> get props => [message, currentPage, totalPages];
}

class MovieSearchLoaded extends MovieState {
  final List<MovieModel> movies;

  const MovieSearchLoaded({
    required this.movies,
    int? currentPage,
    int? totalPages,
  }) : super(currentPage: currentPage, totalPages: totalPages);

  @override
  List<Object?> get props => [movies, currentPage, totalPages];
}
