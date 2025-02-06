import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/Bloc/movie_bloc/movie_cubit.dart';
import 'package:movie_app/models/movie/movie.dart';

import '../constants/strings.dart';

class MoviesByGenreScreen extends StatelessWidget {
  final int genreId;
  final String genreName;

  const MoviesByGenreScreen({super.key, required this.genreId, required this.genreName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(genreName)),
      body: BlocBuilder<MovieCubit, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieLoaded) {
            final movies = state.movies;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                var movie = movies[index];
                return ListTile(
                  title: Text(movie.title ?? 'No title'),
                  leading: movie.posterPath != null
                      ? Image.network('https://image.tmdb.org/t/p/w500${movie.posterPath}', width: 50, fit: BoxFit.cover)
                      : const Icon(Icons.movie),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      movieDetailsScreen,
                      arguments: movie.id,
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text("No movies found for this genre."));
          }
        },
      ),
    );
  }
}
