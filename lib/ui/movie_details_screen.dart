import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/Bloc/MovieDetails_bloc/movie_details_cubit.dart';
import 'package:movie_app/constants/app_fonts.dart';
import 'package:movie_app/models/movie/movie.dart';
import 'package:movie_app/network/service_locator.dart';
import 'package:provider/provider.dart'; // استيراد Provider
import 'package:movie_app/core/utils/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart'; // لاستعراض الفيديو

class MovieDetailScreen extends StatelessWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);

    return BlocProvider(
      create: (context) => getIt<MovieDetailCubit>()..fetchMovieDetail(movieId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Movie Details'),
        //    actions: [
        //   IconButton(
        //     icon: Icon(themeProvider.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
        //     onPressed: () {
        //       themeProvider.toggleTheme(themeProvider.themeMode == ThemeMode.light);
        //     },
        //   ),
        // ],
        ),
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
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20.0),
                            bottom: Radius.circular(20.0)),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.backdropPath ?? 'No Image Available'}',
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        movie.title ?? "No Title",
                        style: AppFonts.textTheme.labelMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        movie.overview ?? "No Description",
                        style: AppFonts.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w400),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Cast',
                          style: AppFonts.textTheme.labelMedium,
                        ),
                      ),
                    ),
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
                                    cast.name,
                                    style: AppFonts.textTheme.displaySmall,
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
                        child: Text('No cast available'),
                      ),
                    const Divider(),
                    if (movie.trailer != null && movie.trailer!.key.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () => _launchURL(movie.trailer!.key),
                            child: Text(
                              'Watch Trailer',
                              style: AppFonts.textTheme.titleSmall,
                            ),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No trailer available'),
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

  Future<void> _launchURL(String videoKey) async {
    final url = Uri.parse('https://www.youtube.com/watch?v=$videoKey');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
