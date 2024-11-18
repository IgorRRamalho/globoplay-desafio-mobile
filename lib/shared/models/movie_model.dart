class Movie {
  final String title;
  final String releaseDate;
  final String posterUrl;

  Movie({
    required this.title,
    required this.releaseDate,
    required this.posterUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? 'Sem título',
      releaseDate: json['release_date'] ?? 'Data não disponível',
      posterUrl: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
    );
  }
}
