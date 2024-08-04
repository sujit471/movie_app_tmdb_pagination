import 'package:http/http.dart' as http;
import 'package:movie_from_api/services/pagination_model.dart';
import 'dart:convert';


class MovieService {
  static const String apiKey = 'e1ae1cedd0acd7b612ca50ad0f738114';
  static const String baseUrl = 'https://api.themoviedb.org/3/movie/now_playing';

  static Future<PaginatedMovies> fetchMovies({int page = 1}) async {
    final response = await _getMoviesFromApi(page);

    if (response.statusCode == 200) {
      return _parseMovies(response.body);
    } else {
      _handleError(response);
      throw Exception('Failed to load movies');
    }
  }

  static Future<http.Response> _getMoviesFromApi(int page) async {
    final url = Uri.parse('$baseUrl?api_key=$apiKey&language=en-US&page=$page');
    try {
      return await http.get(url);
    } catch (e) {
      print('Failed to make network request: $e');
      throw Exception('Network request failed');
    }
  }

  static PaginatedMovies _parseMovies(String responseBody) {
    final Map<String, dynamic> jsonMap = json.decode(responseBody);
    return PaginatedMovies.fromJson(jsonMap);
  }

  static void _handleError(http.Response response) {
    print('Failed to load movies. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
