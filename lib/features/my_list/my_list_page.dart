import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'my_list_controller.dart';

class MyListPage extends ConsumerWidget {
  const MyListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myList = ref.watch(myListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My List'),
      ),
      body: myList.isEmpty
          ? const Center(child: Text('No movies in your list.'))
          : ListView.builder(
              itemCount: myList.length,
              itemBuilder: (context, index) {
                final movie = myList[index];
                return ListTile(
                  title: Text(movie.title),
                  subtitle: Text(movie.releaseDate),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref.read(myListProvider.notifier).removeMovie(movie);
                    },
                  ),
                );
              },
            ),
    );
  }
}
