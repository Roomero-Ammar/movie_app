import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/Bloc/movie_bloc/movie_cubit.dart';
import 'package:movie_app/Bloc/person_bloc/person_cubit.dart';
import 'package:movie_app/Bloc/genre_bloc/genre_cubit.dart';
import 'package:movie_app/constants/app_fonts.dart';
import 'package:movie_app/constants/strings.dart';
import 'package:movie_app/core/utils/theme_provider.dart';
import 'package:movie_app/ui/genre_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Explorer'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme(themeProvider.themeMode == ThemeMode.light);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGenresSection(),
            _buildNowPlayingMovies(),
            _buildTrendingPeople(),
          ],
        ),
      ),
    );
  }

  /// 📌 Fetch & Display Genres (Action, Comedy, Drama...)
 Widget _buildGenresSection() {
  return BlocBuilder<GenreCubit, GenreState>(
    builder: (context, state) {
      if (state is GenreLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is GenreLoaded) {
        final genres = state.genres;
        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: genres.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                 Navigator.pushNamed(
  context,
  moviesByGenreScreen,
  arguments: {
    'genreId': genres[index].id ?? 0, // Use a default value if necessary
    'genreName': genres[index].name ?? 'Unknown',
  },
);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MoviesByGenreScreen(
                    //       categoryInfo:  ,// تمرير الـ genreId و الاسم
                         // genreName: genres[index].name ?? 'Unknown', // تمرير اسم النوع
                    //     ),

                    //   ),
                    // );
                  },
                  child: Chip(
                    label: Text(genres[index].name ?? 'Unknown', style:AppFonts.textTheme.labelSmall?.copyWith(fontSize: 11,fontWeight: FontWeight.w600),),
                   // backgroundColor: Colors.white,
                  ),
                ),
              );
            },
          ),
        );
      }
      return const Center(child: Text('Failed to load genres.'));
    },
  );
}

  /// 🎬 Fetch & Display Now Playing Movies
  Widget _buildNowPlayingMovies() {
    return BlocBuilder<MovieCubit, MovieState>(
      builder: (context, state) {
        if (state is MovieLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MovieError) {
          return Center(child: Text('Error: ${state.error}'));
        } else if (state is MovieLoaded) {
          final movies = state.movies;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
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
        }
        return const Center(child: Text('No movies available.'));
      },
    );
  }

  /// ⭐️ Fetch & Display Trending People (Actors, Directors)
 Widget _buildTrendingPeople() {
  return BlocBuilder<PersonCubit, PersonState>(
    builder: (context, state) {
      if (state is PersonLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is PersonLoaded) {
        final people = state.persons;
        return SizedBox(
  height: 100, // Ensures a fixed height
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal, // Enable horizontal scrolling
    child: Row(
      children: people.map((person) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 35, // Adjust size
                backgroundImage: person.profilePath != null
                    ? NetworkImage('https://image.tmdb.org/t/p/w500${person.profilePath}')
                    : null,
                backgroundColor: Colors.grey.shade300,
                child: person.profilePath == null
                    ? const Icon(Icons.person, size: 35, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 70, // Limit name width
                child: Text(
                  person.name ?? 'Unknown',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  ),
);
 }
      return const Center(child: Text('Failed to load people.'));
    },
  );
}

}