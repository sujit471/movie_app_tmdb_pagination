import 'package:bloc/bloc.dart';
import 'package:movie_from_api/services/movie_model.dart';
import '../services/movie_service.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  List<MovieModel> allMovies = [];

  MovieBloc() : super(MovieInitial()) {
    on<FetchMovies>(_onFetchMovies);
   on<SearchMovies>(_onSearchMovies);
  }

  Future<void> _onFetchMovies(FetchMovies event, Emitter<MovieState> emit) async {
    try {
      emit(MovieLoading());
      // Assume MovieService.fetchMovies fetches movies based on the page number
      final paginatedMovies = await MovieService.fetchMovies(page: event.page);
      allMovies.addAll(paginatedMovies.movies);
      emit(MovieLoaded(allMovies));
    } catch (e) {
      emit(MovieError('Failed to load movies'));
    }
  }

  void _onSearchMovies(SearchMovies event, Emitter<MovieState> emit) {
    print(event.query);
    try {
      emit(MovieLoading());
      final filteredMovies = allMovies
          .where((movie) => movie.title.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(MovieSearchLoaded(filteredMovies));
    } catch (e) {
      emit(MovieError('Failed to search movies'));
    }
  }
}
