import 'package:bloc/bloc.dart';
import 'package:movie_from_api/services/movie_model.dart';
import '../services/movie_service.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  List<MovieModel> allMovies = [];

  MovieBloc() : super( MovieInitial()) {
    on<FetchMovies>(_onFetchMovies);
    on<SearchMovies>(_onSearchMovies);
  }

  Future<void> _onFetchMovies(FetchMovies event, Emitter<MovieState> emit) async {
    try {
      // Use currentPage and totalPages from the state with a default of 1
      final currentPage = state.currentPage ?? 1;
      final totalPages = state.totalPages ?? 1;

      if (currentPage > totalPages) return; // Stop if there are no more pages

      emit(MovieLoading(movies: allMovies, currentPage: currentPage, totalPages: totalPages));

      // Fetch movies from the API
      final paginatedMovies = await MovieService.fetchMovies(page: currentPage);
      final newTotalPages = paginatedMovies.totalPages; // Update total pages
      allMovies.addAll(paginatedMovies.movies);

      emit(MovieLoaded(
        movies: allMovies,
        currentPage: currentPage + 1, // Increment page for the next fetch
        totalPages: newTotalPages,
      ));
    } catch (e) {
      emit(MovieError('Failed to load movies', currentPage: state.currentPage, totalPages: state.totalPages));
    }
  }

  void _onSearchMovies(SearchMovies event, Emitter<MovieState> emit) {
    try {
      emit(MovieLoading(movies: [], currentPage: state.currentPage, totalPages: state.totalPages));

      final filteredMovies = allMovies
          .where((movie) => movie.title.toLowerCase().contains(event.query.toLowerCase()))
          .toList();

      emit(MovieSearchLoaded(movies: filteredMovies, currentPage: state.currentPage, totalPages: state.totalPages));
    } catch (e) {
      emit(MovieError('Failed to search movies', currentPage: state.currentPage, totalPages: state.totalPages));
    }
  }
}
