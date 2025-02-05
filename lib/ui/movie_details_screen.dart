import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/Bloc/MovieDetails_bloc/movie_details_cubit.dart';
import 'package:movie_app/models/movie/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Details')),
      body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieDetailLoaded) {
            Movie movie = state.movie;
            return Column(
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.backdropPath ?? 'No Image Available'}',
                  height: 300,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    movie.title ?? "No Title",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(movie.overview ?? "No Description"),
                ),
              ],
            );
          } else {
            return const Center(child: Text("Failed to load details"));
          }
        },
      ),
    );
  }
}
