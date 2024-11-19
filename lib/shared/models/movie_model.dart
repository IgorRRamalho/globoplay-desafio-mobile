class Movie {
  final int id;
  final String title;
  final String releaseDate;
  final String posterUrl;
  final String overview;
  final String? originalTitle;
  final List<int> genreIds;
  final String? originalLanguage;

  Movie({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.posterUrl,
    required this.overview,
    this.originalTitle,
    this.genreIds = const [],
    this.originalLanguage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? 'Sem título',
      releaseDate: json['release_date'] ?? 'Data não disponível',
      posterUrl: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : 'https://via.placeholder.com/500x750',
      overview: json['overview'] ?? 'Sinopse não disponível.',
      originalTitle: json['original_title'],
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((genreId) => genreId as int)
              .toList() ??
          [],
      originalLanguage: json['original_language'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'release_date': releaseDate,
      'poster_path': posterUrl,
      'overview': overview,
      'original_title': originalTitle,
      'genre_ids': genreIds,
      'original_language': originalLanguage
    };
  }

  String getCountryName() {
    switch (originalLanguage) {
      case 'en':
        return 'Estados Unidos/Inglaterra';
      case 'ja':
        return 'Japão';
      case 'br':
        return 'Brasil';
      case 'es':
        return 'Espanha';
      case 'lv':
        return 'Letônia (Latvia)';
      case 'zh':
        return 'China';
      default:
        return originalLanguage.toString();
    }
  }
}
