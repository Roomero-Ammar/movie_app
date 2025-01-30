import 'package:flutter/material.dart';
import 'package:movie_app/models/movie/movie.dart';
import 'package:movie_app/network/api_result.dart';
import 'package:movie_app/network/api_service.dart';
import 'package:movie_app/network/repo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieRepository _movieRepository = MovieRepository(ApiService());
  late Future<ApiResult<List<Results>>> _nowPlayingMovies;

  @override
  void initState() {
    super.initState();
    _nowPlayingMovies = _movieRepository.fetchNowPlayingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing Movies'),
      ),
      body: FutureBuilder<ApiResult<List<Results>>>(
        future: _nowPlayingMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available.'));
          } else {
            return snapshot.data!.when(
              success: (movies) {
                if (movies.isEmpty) {
                  return const Center(child: Text('No movies available.'));
                }
                return ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    var movie = movies[index];
                    return ListTile(
                      title: Text(movie.title ?? 'No title'),
                      subtitle: Text(movie.overview ?? 'No description'),
                      leading: movie.posterPath != null
                          ? Image.network(
                              'https://image.tmdb.org/t/p/w500${movie.posterPath}')
                          : const Icon(Icons.movie),
                    );
                  },
                );
              },
              failure: (error) {
                return Center(child: Text('Error: ${error.toString()}'));
              },
            );
          }
        },
      ),
    );
  }
}

