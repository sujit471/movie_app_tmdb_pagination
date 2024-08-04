import 'package:flutter/material.dart';
import 'package:movie_from_api/constant/colors.dart';
import 'package:movie_from_api/screens/details.dart';
import 'package:movie_from_api/widget/Image.dart';
import 'package:movie_from_api/widget/push_to_next.dart';
import '../services/movie_model.dart';
import '../services/movie_service.dart';
import '../services/pagination_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> with NavigationToPage {
  int _currentPage = 1;
  int _totalPages = 1;
  List<MovieModel> _movies = [];
  bool _isLoading = false;
  bool _isGridView = false;
  bool _hasMoreMovies = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchMovies();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          !_isLoading && _hasMoreMovies) {
        _loadNextPage();
      }
    });
  }

  Future<void> _fetchMovies() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      PaginatedMovies paginatedMovies = await MovieService.fetchMovies(page: _currentPage);
      setState(() {
        if (_currentPage == 1) {
          _movies = paginatedMovies.movies;
        } else {
          _movies.addAll(paginatedMovies.movies);
        }
        _totalPages = paginatedMovies.totalPages;
        _hasMoreMovies = _currentPage < _totalPages;
      });
    } catch (e) {
      print('Error fetching movies: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadNextPage() {
    if (_hasMoreMovies) {
      setState(() {
        _currentPage++;
      });
      _fetchMovies();
    }
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



  Widget _buildMoviesList() {
    if (_isGridView) {
      return GridView.builder(
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 6.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: _movies.length + (_hasMoreMovies ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _movies.length) {
            return _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : const SizedBox.shrink();
          } else {
            final movie = _movies[index];
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
        itemCount: _movies.length + (_hasMoreMovies ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _movies.length) {
            return _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : const SizedBox.shrink();
          } else {
            return _buildMovieItem(_movies[index]);
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
        title:  Text('Movies',style: CustomStyleText.header(),),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_on),color: Colors.white,
            onPressed: _toggleView,
          ),
        ],
      ),
      body: _isLoading && _movies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _buildMoviesList(),
    );
  }
}
