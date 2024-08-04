import 'package:flutter/material.dart';
import 'package:movie_from_api/screens/details.dart';
import 'package:movie_from_api/services/movie_model.dart';
import 'package:movie_from_api/constant/colors.dart';
import '../widget/push_to_next.dart';

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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: PreferredSize(
          
          preferredSize:Size.fromHeight(120),
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
                        prefixIcon: const Icon(Icons.search,color: Colors.white,),
                        suffixIcon: const Icon(Icons.menu,color: Colors.white,),
                        hintText: 'Search Movies',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (query) {
                        setState(() {
                          _filteredMovies = widget.movies
                              .where((movie) => movie.title.toLowerCase().contains(query.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                ),
              ),
              backgroundColor: primaryColor,
            ),
          ),
        ),
        body: _controller.text.isEmpty
            ? Center(child: Text('Type to search for movies ...',style: CustomStyleText.header(),))
            : _filteredMovies.isEmpty
            ? Center(child: Text('No movies found',style: CustomStyleText.subheader(),))
            : ListView.builder(
          itemCount: _filteredMovies.length,
          itemBuilder: (context, index) {
            final movie = _filteredMovies[index];
            return ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title,style: CustomStyleText.subheader(),),
                    Divider(thickness: 1,),
                  ],
                ),
              ),
              onTap: () {
                navigateTo(context, MovieDetailPage(movie: movie));
              },
            );
          },
        ),
      ),
    );
  }
}
