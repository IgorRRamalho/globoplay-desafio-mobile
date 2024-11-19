import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:globoplay_flutter/shared/models/movie_model.dart';

class MyListController extends StateNotifier<List<Movie>> {
  MyListController() : super([]);

  void addMovie(Movie movie) {
    state = [...state, movie];
  }

  void removeMovie(Movie movie) {
    state = state.where((m) => m != movie).toList();
  }

  void clearList() {
    state = [];
  }

  static Movie fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      releaseDate: json['release_date'],
      posterUrl: json['poster_path'],
      overview: json['overview'] ?? 'Descrição não disponível.',
      originalTitle: json['original_title'],
      genreIds: json['genre_ids'],
     );
  }

  static List<Movie> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }
}

final myListProvider =
    StateNotifierProvider<MyListController, List<Movie>>((ref) {
  return MyListController();
});

final selectedMovieProvider = StateProvider<Movie?>((ref) => null);