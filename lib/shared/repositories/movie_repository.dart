// shared/repositories/movie_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:globoplay_flutter/shared/models/movie_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define o provider global para o repositório de filmes
final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepository();
});

class MovieRepository {
  final String _apiKey =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiYWI2MGI3ZTBjY2M2N2Y2ZDRjZDljZTY1ODVkY2EwMSIsIm5iZiI6MTczMTkxODA1MS41OTI4MzU3LCJzdWIiOiI2NzNhZjJkNWY3NDFlYjA0MjhiNjI0NTMiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.1uOFgdiZIff-1_5P3Msy1IMkgoCCrx10TPCmyO2Pd4o';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  // Método para obter todos os filmes divididos por categorias (gêneros)
  Future<Map<String, List<Movie>>> fetchMovies() async {
    try {
      // Obter lista de gêneros
      final genresResponse = await http.get(Uri.parse(
          '$_baseUrl/genre/movie/list?api_key=$_apiKey&language=pt-BR'));
      if (genresResponse.statusCode != 200) {
        throw Exception('Falha ao carregar gêneros');
      }

      final List genres = jsonDecode(genresResponse.body)['genres'];
      final Map<String, List<Movie>> categorizedMovies = {};

      // Buscar filmes para cada gênero
      for (var genre in genres) {
        final genreId = genre['id'];
        final genreName = genre['name'];

        final moviesResponse = await http.get(Uri.parse(
            '$_baseUrl/discover/movie?api_key=$_apiKey&language=pt-BR&with_genres=$genreId'));

        if (moviesResponse.statusCode == 200) {
          final List<Movie> movies = _parseMovies(moviesResponse.body);
          categorizedMovies[genreName] = movies;
        } else {
          throw Exception('Falha ao carregar filmes para o gênero $genreName');
        }
      }

      return categorizedMovies;
    } catch (e) {
      throw Exception('Erro ao buscar filmes: $e');
    }
  }

  List<Movie> _parseMovies(String responseBody) {
    final Map<String, dynamic> json = jsonDecode(responseBody);
    final List results = json['results'];
    return results.map((movie) => Movie.fromJson(movie)).toList();
  }
}
