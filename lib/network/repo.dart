import 'package:dio/dio.dart';
import 'package:movie_app/models/movie/movie.dart';

import 'api_result.dart';
import 'api_service.dart';
import 'network_exceptions.dart';

class MovieRepository {
  final ApiService _apiService;

  MovieRepository(this._apiService);

  Future<ApiResult<List<Results>>> fetchNowPlayingMovies() async {
    try {
      final response = await _apiService.get('/movie/now_playing');
      final movies = (response.data['results'] as List)
          .map((m) => Results.fromJson(m))
          .toList();
      return ApiResult.success(movies);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<List<Results>>> fetchMoviesByGenre(int genreId) async {
    try {
      final response = await _apiService
          .get('/discover/movie', params: {'with_genres': genreId});
      final movies = (response.data['results'] as List)
          .map((m) => Results.fromJson(m))
          .toList();
      return ApiResult.success(movies);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<List<Genre>>> fetchGenres() async {
    try {
      final response = await _apiService.get('/genre/movie/list');
      final genres = (response.data['genres'] as List)
          .map((g) => Genre.fromJson(g))
          .toList();
      return ApiResult.success(genres);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<List<Person>>> fetchTrendingPersons() async {
    try {
      final response = await _apiService.get('/trending/person/week');
      final persons = (response.data['results'] as List)
          .map((p) => Person.fromJson(p))
          .toList();
      return ApiResult.success(persons);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<Movie>> fetchMovieDetail(int movieId) async {
    try {
      final response = await _apiService.get('/movie/$movieId');
      final movie = Movie.fromJson(response.data);

      // Fetch additional details
      final youtubeIdResult = await fetchYoutubeId(movieId);
      final imagePathResult = await fetchMovieImage(movieId);
      final castListResult = await fetchCastList(movieId);

      // Check if any of the ApiResult calls failed
      if (youtubeIdResult is Failure ||
          imagePathResult is Failure ||
          castListResult is Failure) {
        return ApiResult.failure(
            NetworkExceptions.getDioException("Failed to fetch movie details"));
      }

      if (movie.results != null && movie.results!.isNotEmpty) {
        movie.results![0].trailerId =
            (youtubeIdResult as Success<YoutubeVideo>).data.key;
        movie.results![0].posterPath =
            (imagePathResult as Success<MovieImage>).data.filePath;
        movie.results![0].genreIds = (castListResult as Success<List<Cast>>)
            .data
            .map((cast) => cast.id)
            .toList();
      }

      return ApiResult.success(movie);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<YoutubeVideo>> fetchYoutubeId(int movieId) async {
    try {
      final response = await _apiService.get('/movie/$movieId/videos');
      if (response.data['results'].isNotEmpty) {
        return ApiResult.success(
            YoutubeVideo.fromJson(response.data['results'][0]));
      } else {
        return ApiResult.failure(
            NetworkExceptions.getDioException("No video found"));
      }
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<MovieImage>> fetchMovieImage(int movieId) async {
    try {
      final response = await _apiService.get('/movie/$movieId/images');
      if (response.data['posters'].isNotEmpty) {
        return ApiResult.success(
            MovieImage.fromJson(response.data['posters'][0]));
      } else {
        return ApiResult.failure(
            NetworkExceptions.getDioException("No image found"));
      }
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<List<Cast>>> fetchCastList(int movieId) async {
    try {
      final response = await _apiService.get('/movie/$movieId/credits');
      final castList =
          (response.data['cast'] as List).map((c) => Cast.fromJson(c)).toList();
      return ApiResult.success(castList);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }
}
