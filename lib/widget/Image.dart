import 'package:flutter/material.dart';
import 'package:movie_from_api/screens/details.dart';
import 'package:movie_from_api/widget/push_to_next.dart';
import 'package:shimmer/shimmer.dart';
import 'package:movie_from_api/services/movie_model.dart';

class MoviePoster extends StatefulWidget {
  final MovieModel movie;
  const MoviePoster({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  _MoviePosterState createState() => _MoviePosterState();
}

class _MoviePosterState extends State<MoviePoster> with NavigationToPage {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateTo(context, MovieDetailPage(movie: widget.movie));
      },
      child: Container(
        height: 280,
        width: 170,
        child: SizedBox(
          height: 280,
          width:170,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      color: Colors.white,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
