import 'movie_model.dart';

class PaginatedMovies {
  final List<MovieModel> movies;
  final int totalPages;

  PaginatedMovies({required this.movies, required this.totalPages});

  factory PaginatedMovies.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonList = json['results'];
    final int totalPages = json['total_pages'];
    return PaginatedMovies(
      movies: MovieModel.fromJsonList(jsonList),
      totalPages: totalPages,
    );
  }
}
