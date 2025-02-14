import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                      margin:  EdgeInsets.symmetric(vertical: 8.0.w, horizontal: 4.0.h),
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
                                :  Icon(Icons.movie, size: 50.sp, color: Colors.grey),
                          ),
                          Padding(
                            padding:  EdgeInsets.all(8.0).w,
                            child: Text(
                              movie.title ?? 'No title',
                              style:  TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 8.0.h, vertical: 4.0.w),
                            child: Text(
                              'Release: ${movie.releaseDate?.substring(0, 4) ?? 'Unknown'}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                 Icon(Icons.star, color: Colors.yellow, size: 16),
                                 SizedBox(width: 4.w),
                                Text(
                                  movie.voteAverage?.toStringAsFixed(1) ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: 14.sp,
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