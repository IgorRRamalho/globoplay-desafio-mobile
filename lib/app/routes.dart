import 'package:flutter/material.dart';
import '../features/splash/splash_page.dart';
import '../features/home/home_page.dart';
import '../features/my_list/my_list_page.dart';
import '../features/movie_info/movie_info_page.dart';

class Routes {
  static const splash = '/';
  static const home = '/home';
  static const myList = '/my-list';
  static const movieInfo = '/movie-info';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashPage(),
      home: (context) => const HomePage(),
      myList: (context) => const MyListPage(),
      movieInfo: (context) => const MovieInfoPage(),
    };
  }
}
