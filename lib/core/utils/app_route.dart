import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/Bloc/MovieDetails_bloc/movie_details_cubit.dart';
import 'package:movie_app/Bloc/movie_bloc/movie_cubit.dart';
import 'package:movie_app/Bloc/person_bloc/person_cubit.dart';
import 'package:movie_app/Bloc/genre_bloc/genre_cubit.dart';
import 'package:movie_app/constants/strings.dart';
import 'package:movie_app/network/service_locator.dart';
import 'package:movie_app/ui/home_screen.dart';
import 'package:movie_app/ui/movie_details_screen.dart';
import 'package:movie_app/network/api_service.dart';
import 'package:movie_app/network/repo.dart';

class AppRouter {
  late MovieRepository movieRepository;

  AppRouter() {
    movieRepository = MovieRepository(ApiService());
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              // BlocProvider(create: (context) => MovieCubit(movieRepository)..fetchNowPlayingMovies()),  // without using getIt

              BlocProvider(create: (context) => getIt<MovieCubit>()),
              BlocProvider(create: (context) => PersonCubit(movieRepository)..fetchTrendingPersons()),
              BlocProvider(create: (context) => GenreCubit(movieRepository)..fetchGenres()),
            ],
            child: const HomeScreen(),
          ),
        );

      case movieDetailsScreen:
        final movieId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => MovieDetailCubit(movieRepository)..fetchMovieDetail(movieId),
            child: MovieDetailScreen(movieId: movieId),
          ),
        );

      default:
        return null;
    }
  }
}
