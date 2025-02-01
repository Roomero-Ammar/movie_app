import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/Bloc/movie_bloc/movie_cubit.dart';
import 'package:movie_app/constants/strings.dart';
import 'package:movie_app/ui/home_screen.dart';
import 'package:movie_app/network/api_service.dart';
import 'package:movie_app/network/repo.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => MovieCubit(MovieRepository(ApiService()))..fetchNowPlayingMovies(),
            child: const HomeScreen(),
          ),
        );
      default:
        return null; // يمكنك إضافة حالة افتراضية هنا
    }
  }
}