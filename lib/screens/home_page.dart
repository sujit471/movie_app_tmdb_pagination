import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_from_api/constant/colors.dart';
import 'package:movie_from_api/constant/space.dart';
import 'package:movie_from_api/screens/search_result.dart';
import 'package:movie_from_api/bloc/movie_bloc.dart';
import 'package:movie_from_api/bloc/movie_event.dart';
import 'package:movie_from_api/bloc/movie_state.dart';
import '../services/movie_model.dart';
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

class _HomePageState extends State<HomePage> with NavigationToPage {
  final PageController _pageController = PageController(viewportFraction: 0.55);
  int _currentPage = 0;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(FetchMovies());
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  Widget _buildMoviesList(List<MovieModel> movies) {
    final displayedMovies = movies.take(5).toList();
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
              itemCount: displayedMovies.length,
              itemBuilder: (context, index) {
                final isCenter = index == _currentPage;
                final movie = displayedMovies[index];
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
          Indicator(itemCount: displayedMovies.length, currentPage: _currentPage),
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
              itemCount: displayedMovies.length,
              itemBuilder: (context, index) {
                final movie = displayedMovies[index];
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
                          builder: (context) => const SearchResultsPage(
                            searchQuery: '',
                            movies: [],
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
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.search, color: Colors.white),
                                    Width(15),
                                    Text('Search Movies...',
                                        style: CustomStyleText.subheader()),
                                  ],
                                ),
                                const Icon(Icons.menu, color: Colors.white),
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
        body: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieLoaded) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildMoviesList(state.movies),
              );
            } else if (state is MovieError) {
              return Center(child: Text(state.message, style: CustomStyleText.header()));
            }
            return const Center(child: Text('No Movies Found'));
          },
        ),
      ),
    );
  }
}
