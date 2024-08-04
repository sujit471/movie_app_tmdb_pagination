import 'package:flutter/material.dart';
import 'package:movie_from_api/constant/colors.dart';
import 'package:movie_from_api/constant/space.dart';
import 'package:movie_from_api/services/movie_model.dart';
import 'package:movie_from_api/widget/Image.dart';
import 'package:movie_from_api/widget/items_in_row.dart';

class MovieDetailPage extends StatelessWidget {
  final MovieModel movie;
  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        title: Text(

          movie.title,
          style: CustomStyleText.header(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Height(30),
                MoviePoster(
                  movie: movie,
                ),
                Height(20),
                Text('Title : ${movie.title}', style: CustomStyleText.header()),
                RichText(text:  TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Overview: ',style: CustomStyleText.header()),
                    TextSpan(text: movie.overview,style: CustomStyleText.subheader(
                      height: 1.5,
                    )),
                  ]
                )),
                Height(20),

                ItemsInRow(
                    text: 'Language :${movie.originalLanguage}',
                    image: Icons.language,color: Colors.green),
                Height(20),
                ItemsInRow(
                    text: 'Adult : ${movie.adult}',
                    image: Icons.no_adult_content,color: Colors.red,),
                Height(20),
                ItemsInRow(
                    text: 'Vote Count : ${movie.voteCount}',
                    image: Icons.how_to_vote,color: Colors.greenAccent),
                Height(20),
                ItemsInRow(
                    text: 'Average Vote : ${movie.voteAverage}',
                    image: Icons.where_to_vote_outlined,color: Colors.red,),
                Height(20),
                ItemsInRow(
                    text: 'Average Vote : ${movie.popularity}',
                    image: Icons.star,color: Colors.yellow,),
Height(20),
 ItemsInRow(text: 'Release date : ${movie.releaseDate}', image: Icons.calendar_month)
              ],



            ),
          ),
        ),
      ),
    );
  }
}
