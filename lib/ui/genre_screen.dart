import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/Bloc/movie_bloc/movie_cubit.dart';
import 'package:movie_app/models/movie/movie.dart';
import 'package:movie_app/network/service_locator.dart';
import '../constants/strings.dart';

class MoviesByGenreScreen extends StatelessWidget {
  final ({int genreId, String genreName}) categoryInfo;

  const MoviesByGenreScreen({super.key, required this.categoryInfo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieCubit>(
      create: (context) => getIt<MovieCubit>()..fetchMoviesByGenre(categoryInfo.genreId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            categoryInfo.genreName,
           // style: const TextStyle(color: Colors.white),
          ),
        //  backgroundColor: Colors.deepPurple,
        ),
        body: BlocBuilder<MovieCubit, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieLoaded) {
              final movies = state.movies;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7, // Maintain the aspect ratio
                ),
                itemCount: movies.length,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  var movie = movies[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        movieDetailsScreen,
                        arguments: movie.id,
                      );
                    },
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: movie.posterPath != null
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4.0)),
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(Icons.movie, size: 50, color: Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              movie.title ?? 'No title',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Text(
                              'Release: ${movie.releaseDate?.substring(0, 4) ?? 'Unknown'}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.yellow, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  movie.voteAverage?.toStringAsFixed(1) ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is MovieError) {
              return Center(child: Text(state.error));
            } else {
              return const Center(child: Text("No movies found for this genre."));
            }
          },
        ),
      ),
    );
  }
}