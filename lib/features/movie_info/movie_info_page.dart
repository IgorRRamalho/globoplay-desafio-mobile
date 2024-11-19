import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:globoplay_flutter/shared/models/movie_model.dart';
import 'package:globoplay_flutter/shared/repositories/movie_repository.dart';
import 'package:globoplay_flutter/shared/controller/my_list_controller.dart';

class MovieInfoPage extends ConsumerWidget {
  const MovieInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movie = ModalRoute.of(context)?.settings.arguments as Movie?;

    if (movie == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: Text(
            'Filme não encontrado!',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      );
    }

    final relatedMoviesAsync = ref.watch(relatedMoviesProvider(movie.genreIds));
    final genresAsync = ref.watch(genresProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                movie.posterUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(color: Colors.black.withOpacity(0.7)),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        movie.posterUrl,
                        width: 150,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      movie.overview,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow, color: Colors.black),
                          label: const Text('Assista', style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size(140, 40),
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, _) {
                            final myList = ref.watch(myListProvider);
                            final isAdded = myList.any((m) => m.id == movie.id);

                            return OutlinedButton.icon(
                              onPressed: () {
                                final notifier = ref.read(myListProvider.notifier);
                                if (isAdded) {
                                  notifier.removeMovie(movie);
                                } else {
                                  notifier.addMovie(movie);
                                }
                              },
                              icon: Icon(
                                isAdded ? Icons.check : Icons.star_border,
                                color: Colors.white,
                              ),
                              label: Text(
                                isAdded ? 'Adicionado' : 'Minha Lista',
                                style: const TextStyle(color: Colors.white),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white),
                                minimumSize: const Size(140, 40),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    indicatorPadding: EdgeInsets.zero,
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: 'ASSISTA TAMBÉM'),
                      Tab(text: 'DETALHES'),
                    ],
                  ),
                  SizedBox(
                    height: 300,
                    child: Container(
                      color: Colors.grey[900],
                      child: TabBarView(
                        children: [
                          // aba "Assista Também"
                          relatedMoviesAsync.when(
                            data: (relatedMovies) => _buildRelatedMovies(relatedMovies),
                            loading: () => const Center(
                              child: CircularProgressIndicator(color: Colors.white),
                            ),
                            error: (error, stackTrace) => Center(
                              child: Text(
                                'Erro ao carregar filmes relacionados: $error',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          // aba "Detalhes"
                          genresAsync.when(
                            data: (genres) => _buildMovieDetails(movie, genres, ref),
                            loading: () => const Center(
                              child: CircularProgressIndicator(color: Colors.white),
                            ),
                            error: (error, stackTrace) => Center(
                              child: Text(
                                'Erro ao carregar gêneros: $error',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildRelatedMovies(List<Movie> relatedMovies) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SingleChildScrollView(
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: relatedMovies.length,
            itemBuilder: (context, index) {
              final movie = relatedMovies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/movie-info',
                    arguments: movie,
                  );
                },
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        movie.posterUrl,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );
}

  Widget _buildMovieDetails(Movie movie, Map<int, String> genres, WidgetRef ref) {
    final genreNames = movie.genreIds.map((id) => genres[id] ?? 'Desconhecido').join(', ');

    final castAsync = ref.watch(movieCastProvider(movie.id));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ficha técnica',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildDetailRow('Título Original:', movie.originalTitle ?? 'Desconhecido'),
          _buildDetailRow('Gênero:', genreNames),
          _buildDetailRow('Ano de produção:', movie.releaseDate.split('-').first),
          _buildDetailRow('País:', movie.getCountryName()),
          const SizedBox(height: 8),
          castAsync.when(
            data: (cast) {
              final castNames = cast.map((actor) => actor['name'] ?? 'Desconhecido').join(', ');
              return _buildDetailRow('Elenco:', castNames);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Text(
              'Erro ao carregar elenco: $error',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey.shade300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
