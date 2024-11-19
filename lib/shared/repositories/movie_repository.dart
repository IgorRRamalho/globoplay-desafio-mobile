import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:globoplay_flutter/shared/models/movie_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepository();
});

final relatedMoviesProvider =
    FutureProvider.family<List<Movie>, List<int>>((ref, genreIds) async {
  final movieRepository = ref.read(movieRepositoryProvider);
  return movieRepository.fetchRelatedMovies(genreIds);
});

final genresProvider = FutureProvider<Map<int, String>>((ref) async {
  final movieRepository = ref.read(movieRepositoryProvider);
  return movieRepository.fetchGenres();
});

final movieCastProvider =
    FutureProvider.family<List<Map<String, String>>, int>((ref, movieId) async {
  final movieRepository = ref.read(movieRepositoryProvider);
  return movieRepository.fetchMovieCast(movieId);
});

class MovieRepository {
  final String _bearerToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4M2JiNWY3NzliZWM3N2UzMGY3MzZjMWZlMDE5ZmU3YiIsIm5iZiI6MTczMTk1MDc1MC4wODA4MzY4LCJzdWIiOiI2NzNiNzdkZTc0YTJlNmUwMjM3YjZjZWYiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.zzkYESV2V__Twdm0OEWTwDcdWbKPKghIGab6K0eJ8c4';

  final String _baseUrl = 'https://api.themoviedb.org/3';

// elenco
  Future<List<Map<String, String>>> fetchMovieCast(int movieId) async {
    final url = '$_baseUrl/movie/$movieId/credits';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $_bearerToken',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List cast = json['cast'];

      return cast
          .map((actor) => {
                'name': actor['name']?.toString() ?? 'Desconhecido',
                'profilePath': actor['profile_path'] != null
                    ? 'https://image.tmdb.org/t/p/w500${actor['profile_path']}'
                    : '',
              })
          .take(10)
          .toList();
    } else {
      throw Exception('Erro ao buscar elenco: ${response.body}');
    }
  }

  Future<Map<int, String>> fetchGenres() async {
    final url = '$_baseUrl/genre/movie/list?language=pt-BR';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $_bearerToken',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List genres = json['genres'];
      return {for (var genre in genres) genre['id']: genre['name']};
    } else {
      throw Exception('Erro ao buscar gêneros: ${response.body}');
    }
  }

  Future<List<Movie>> fetchRelatedMovies(List<int> genreIds) async {
    final genres = genreIds.join(',');
    final url = '$_baseUrl/discover/movie?with_genres=$genres&language=pt-BR';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $_bearerToken',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List results = json['results'];
      return results.map((movieJson) => Movie.fromJson(movieJson)).toList();
    } else {
      throw Exception('Erro ao buscar filmes relacionados: ${response.body}');
    }
  }

  Future<Map<String, List<Movie>>> fetchMovies() async {
    try {
      final genresResponse = await http.get(
        Uri.parse('$_baseUrl/genre/movie/list?language=pt-BR'),
        headers: {
          'Authorization': 'Bearer $_bearerToken',
          'Content-Type': 'application/json;charset=utf-8',
        },
      );

      if (genresResponse.statusCode != 200) {
        throw Exception('Falha ao carregar gêneros');
      }

      final List genres = jsonDecode(genresResponse.body)['genres'];
      final Map<String, List<Movie>> categorizedMovies = {};

      for (var genre in genres) {
        final genreId = genre['id'];
        final genreName = genre['name'];

        final moviesResponse = await http.get(
          Uri.parse(
              '$_baseUrl/discover/movie?language=pt-BR&with_genres=$genreId'),
          headers: {
            'Authorization': 'Bearer $_bearerToken',
            'Content-Type': 'application/json;charset=utf-8',
          },
        );

        if (moviesResponse.statusCode == 200) {
          final List<Movie> movies = _parseMovies(moviesResponse.body);
          categorizedMovies[genreName] = movies;
        } else {
          throw Exception(
              'Falha ao carregar filmes para o gênero $genreName: ${moviesResponse.body}');
        }
      }

      return categorizedMovies;
    } catch (e) {
      throw Exception('Erro ao buscar filmes: $e');
    }
  }
}

List<Movie> _parseMovies(String responseBody) {
  final Map<String, dynamic> json = jsonDecode(responseBody);
  final List results = json['results'];
  return results.map((movie) => Movie.fromJson(movie)).toList();
}
