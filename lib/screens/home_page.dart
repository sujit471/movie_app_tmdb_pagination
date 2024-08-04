import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movie_from_api/constant/colors.dart';
import 'package:movie_from_api/constant/space.dart';
import 'package:movie_from_api/screens/search_result.dart';
import 'package:movie_from_api/services/movie_model.dart';
import 'package:movie_from_api/services/movie_service.dart';
import 'package:movie_from_api/services/pagination_model.dart';

import '../widget/Image.dart';
import '../widget/movie_list.dart';
import '../widget/page_indicator.dart';
import '../widget/push_to_next.dart';
import 'details.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with  NavigationToPage{
  late Future<PaginatedMovies> futureMovies;
  List<MovieModel> _movies = [];

  String _searchQuery = '';
  final PageController _pageController = PageController(viewportFraction: 0.55);
  int _currentPage = 0;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _fetchAllMovies();

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  Future<void> _fetchAllMovies({int page = 1}) async {
    futureMovies = MovieService.fetchMovies(page: page);
    futureMovies.then((paginatedMovies) {
      setState(() {
        _movies.addAll(paginatedMovies.movies);
        _totalPages = paginatedMovies.totalPages;
        if (page < _totalPages) {
          _fetchAllMovies(page: page + 1);
        }
      });
    });
  }

  List<MovieModel> _filterMovies(String query) {
    if (query.isEmpty) {
      return [];
    } else {
      return _movies
          .where((movie) =>
              movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  Widget _buildMoviesList() {
    final movies = _movies.take(5).toList();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Now Showing", style: CustomStyleText.header()),
          ),
Height(20),
          SizedBox(
            height: 305,
            child: PageView.builder(
              controller: _pageController,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final isCenter = index == _currentPage;
                final movie = movies[index];
                final scale = isCenter ? 1.0 : 0.8;
                return TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween(begin: scale, end: scale),
                  curve: Curves.ease,
                  builder: (BuildContext context, double value, Widget? child) {
                    return Transform.scale(
                      scale: scale,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: ClipRRect(
                          child: ImageFiltered(
                            enabled: !isCenter,
                            imageFilter: ImageFilter.blur(
                                sigmaX: 3, sigmaY: 3, tileMode: TileMode.clamp),
                            child: MoviePoster(movie: movie),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Indicator(itemCount: movies.length, currentPage: _currentPage),
          Height(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Animation Film', style: CustomStyleText.header()),
              GestureDetector(
                onTap: () {
                navigateTo(context, MoviesPage());
                },
                child: Text('See more', style: CustomStyleText.subheader()),
              ),
            ],
          ),
     Height(30),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                final movie = _movies[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: MoviePoster(movie: movie),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(210),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, top: 16.0, bottom: 16.0, right: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hello Aliza", style: CustomStyleText.header()),
                          Text('Book your favourite movie',
                              style: CustomStyleText.subheader()),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        child: const Icon(Icons.notifications,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  Height(30),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchResultsPage(
                            searchQuery: _searchQuery,
                            movies: _movies,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'searchBar',
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey,
                          ),
                          child:  Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.search,color: Colors.white,),
                                    Width(15),
                                     Text('Search Movies...',style: CustomStyleText.subheader(),),
                                  ],
                                ),
                                const Icon(Icons.menu,color:Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildMoviesList(),
        ),
      ),
    );
  }
}
