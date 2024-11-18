import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:globoplay_flutter/shared/models/movie_model.dart';
import '../../shared/repositories/movie_repository.dart';

final moviesProvider =
    FutureProvider.autoDispose<Map<String, List<Movie>>>((ref) async {
  final repository = ref.read(movieRepositoryProvider);
  return repository.fetchMovies();
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsyncValue = ref.watch(moviesProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          'assets/geral/globoplay-logo-branca.png',
          height: 30,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: moviesAsyncValue.when(
        data: (categories) {
          return Container(
            color: const Color(0xFF1F1F1F),
            child: ListView(
              children: categories.entries.map((entry) {
                final category = entry.key;
                final movies = entry.value;
                return _CategorySection(category: category, movies: movies);
              }).toList(),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child:
              Text('Erro: $error', style: const TextStyle(color: Colors.white)),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home/home.svg',
              width: 24,
              height: 24,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/star/star.svg',
              width: 24,
              height: 24,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            label: 'Minha lista',
          ),
        ],
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        showUnselectedLabels: true,
      ),
    );
  }
}

@override
Widget build(BuildContext context, WidgetRef ref) {
  final moviesAsyncValue = ref.watch(moviesProvider);

  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      title: Image.asset(
        'assets/geral/globoplay-logo-branca.png',
        height: 30,
      ),
      centerTitle: true,
      elevation: 0,
    ),
    body: moviesAsyncValue.when(
      data: (categories) {
        return Container(
          color: const Color(0xFF1F1F1F),
          child: ListView(
            children: categories.entries.map((entry) {
              final category = entry.key;
              final movies = entry.value;
              return _CategorySection(category: category, movies: movies);
            }).toList(),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child:
            Text('Erro: $error', style: const TextStyle(color: Colors.white)),
      ),
    ),
    bottomNavigationBar: BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/home/home.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/star/star.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          label: 'Minha lista',
        ),
      ],
      selectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      showUnselectedLabels: true,
    ),
  );
}

class _CategorySection extends StatelessWidget {
  final String category;
  final List<Movie> movies;

  const _CategorySection({
    required this.category,
    required this.movies,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            category,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/movie-info',
                        arguments: movie);
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          movie.posterUrl,
                          width: 120,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
