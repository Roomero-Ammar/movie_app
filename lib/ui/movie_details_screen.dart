import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/Bloc/MovieDetails_bloc/movie_details_cubit.dart';
import 'package:movie_app/models/movie/movie.dart';
import 'package:movie_app/network/repo.dart';
import 'package:movie_app/network/service_locator.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this package for launching URLs

class MovieDetailScreen extends StatelessWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MovieDetailCubit>()..fetchMovieDetail(movieId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Movie Details')),
        body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
          builder: (context, state) {
            if (state is MovieDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieDetailLoaded) {
              Movie movie = state.movie;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.backdropPath ?? 'No Image Available'}',
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        movie.title ?? "No Title", // Default Title if missing
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(movie.overview ??
                          "No Description"), // Default Description if missing
                    ),
                    const Divider(),
                    // Show cast information
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Cast:',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Cast list with fallback for empty list
                    if (movie.cast != null && movie.cast!.isNotEmpty)
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movie.cast!.length,
                          itemBuilder: (context, index) {
                            final cast = movie.cast![index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500${cast.profilePath.isNotEmpty ? cast.profilePath : 'default-profile.jpg'}',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    cast.name, // Default Name if missing
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'No cast available'), // Message if no cast available
                      ),
                    const Divider(),
                    // Display trailer if available
                    if (movie.trailer != null && movie.trailer!.key.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => _launchURL(movie.trailer!.key),
                          child: const Text('Watch Trailer'),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'No trailer available'), // Message if no trailer available
                      ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text("Failed to load details"));
            }
          },
        ),
      ),
    );
  }

  // Function to launch the video URL
  Future<void> _launchURL(String videoKey) async {
    final url = Uri.parse('https://www.youtube.com/watch?v=$videoKey');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
