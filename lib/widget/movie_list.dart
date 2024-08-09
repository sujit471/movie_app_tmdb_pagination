import 'package:flutter/material.dart';
import 'package:movie_from_api/bloc/movie_bloc.dart';
import 'package:movie_from_api/constant/colors.dart';
import 'package:movie_from_api/screens/details.dart';
import 'package:movie_from_api/widget/Image.dart';
import 'package:movie_from_api/widget/push_to_next.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';
import '../services/movie_model.dart';
class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> with NavigationToPage {
  bool _isGridView = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        context.read<MovieBloc>().add(FetchMovies());
      }
    });

    context.read<MovieBloc>().add(FetchMovies(page: 1));
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  Widget _buildMovieItem(MovieModel movie) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            navigateTo(context, MovieDetailPage(movie: movie));
          },
          title: Padding(
            padding: const EdgeInsets.all(60.0),
            child: MoviePoster(movie: movie),
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1.0,
          height: 1.0,
          indent: 0,
          endIndent: 0,
        ),
      ],
    );
  }

  Widget _buildMoviesList(List<MovieModel> movies, bool isLoading) {
    if (_isGridView) {
      return GridView.builder(
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 6.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: movies.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == movies.length) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else {
            final movie = movies[index];
            return GestureDetector(
              onTap: () {
                navigateTo(context, MovieDetailPage(movie: movie));
              },
              child: Card(
                child: CachedNetworkImage(
                  imageUrl: 'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }
        },
      );
    } else {
      return ListView.builder(
        controller: _scrollController,
        itemCount: movies.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == movies.length) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else {
            return _buildMovieItem(movies[index]);
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        title: Text('Movies', style: CustomStyleText.header()),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_on),
            color: Colors.white,
            onPressed: _toggleView,
          ),
        ],
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading && state.movies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieLoaded || state is MovieLoading) {
            final movies = state is MovieLoaded ? state.movies : (state as MovieLoading).movies;
            final isLoading = state is MovieLoading;
            return _buildMoviesList(movies, isLoading);
          } else if (state is MovieError) {
            return Center(child: Text('Failed to load movies: ${state.message}', style: const TextStyle(color: Colors.white)));
          } else {
            return const Center(child: Text('No movies found', style: TextStyle(color: Colors.white)));
          }
        },
      ),
    );
  }
}
