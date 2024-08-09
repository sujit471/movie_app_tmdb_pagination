import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:movie_from_api/bloc/movie_bloc.dart';
import 'package:movie_from_api/screens/details.dart';
import 'package:movie_from_api/services/movie_model.dart';
import 'package:movie_from_api/constant/colors.dart';
import '../widget/push_to_next.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_from_api/bloc/movie_bloc.dart';
import 'package:movie_from_api/bloc/movie_event.dart';
import 'package:movie_from_api/bloc/movie_state.dart';

class SearchResultsPage extends StatefulWidget {
  final String searchQuery;
  final List<MovieModel> movies;

  const SearchResultsPage({Key? key, required this.searchQuery, required this.movies}) : super(key: key);

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> with NavigationToPage {
  late List<MovieModel> _filteredMovies;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
    context.read<MovieBloc>().add(SearchMovies(widget.searchQuery));
    _filteredMovies = widget.movies
        .where((movie) => movie.title.toLowerCase().contains(widget.searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              leadingWidth: 25,
              title: SizedBox(
                width: 600,
                child: Hero(
                  tag: 'searchBar',
                  child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _controller,
                      decoration: InputDecoration(
                        counterStyle: const TextStyle(color: Colors.white),
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(Icons.search, color: Colors.white),
                        suffixIcon: const Icon(Icons.menu, color: Colors.white),
                        hintText: 'Search Movies',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (query) {
                        if (query.isNotEmpty) {
                          context.read<MovieBloc>().add(SearchMovies(query));
                        }
                      },
                    ),
                  ),
                ),
              ),
              backgroundColor: primaryColor,
            ),
          ),
        ),
        body: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            log(state.toString());
            // Check if the search field is empty
            if (_controller.text.isEmpty) {
              return Center(
                child: Text(
                  'Type to search for movies ...',
                  style: CustomStyleText.header(),
                ),
              );
            }

            // Display different states
            if (state is MovieLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MovieSearchLoaded) {
              final _filteredMovies = state.movies;
              if (_filteredMovies.isEmpty) {
                return Center(
                  child: Text(
                    'No movies found',
                    style: CustomStyleText.subheader(),
                  ),
                );
              }
              return ListView.builder(
                itemCount: _filteredMovies.length,
                itemBuilder: (context, index) {
                  final movie = _filteredMovies[index];
                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(movie.title, style: CustomStyleText.subheader()),
                          Divider(thickness: 1),
                        ],
                      ),
                    ),
                    onTap: () {
                      navigateTo(context, MovieDetailPage(movie: movie));
                    },
                  );
                },
              );
            } else if (state is MovieError) {
              return Center(
                child: Text(
                  'No movies found',
                  style: CustomStyleText.subheader(),
                ),
              );
            } else {
              return Center(
                child: Text(
                  'Type to search for movies ...',
                  style: CustomStyleText.header(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

}
