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
      final response =
          await _apiService.get('/discover/movie', params: {'with_genres': genreId});
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
      final genres =
          (response.data['genres'] as List).map((g) => Genre.fromJson(g)).toList();
      return ApiResult.success(genres);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<List<Person>>> fetchTrendingPersons() async {
    try {
      final response = await _apiService.get('/trending/person/week');
      final persons =
          (response.data['results'] as List).map((p) => Person.fromJson(p)).toList();
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
      if (youtubeIdResult is Failure || imagePathResult is Failure || castListResult is Failure) {
        return ApiResult.failure(NetworkExceptions.getDioException("Failed to fetch movie details"));
      }

      // If everything is successful, assign the data
      movie.results![0].trailerId = (youtubeIdResult as Success<String>).data;
      movie.results![0].posterPath = (imagePathResult as Success<String>).data;
      movie.results![0].genreIds = (castListResult as Success<List<int>>).data;

      return ApiResult.success(movie);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<String>> fetchYoutubeId(int movieId) async {
    try {
      final response = await _apiService.get('/movie/$movieId/videos');
      final youtubeId = response.data['results'].isNotEmpty
          ? response.data['results'][0]['key']
          : '';
      return ApiResult.success(youtubeId);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<String>> fetchMovieImage(int movieId) async {
    try {
      final response = await _apiService.get('/movie/$movieId/images');
      final imagePath = response.data['posters'].isNotEmpty
          ? response.data['posters'][0]['file_path']
          : '';
      return ApiResult.success(imagePath);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<List<int>>> fetchCastList(int movieId) async {
    try {
      final response = await _apiService.get('/movie/$movieId/credits');
      final castList = (response.data['cast'] as List)
          .map((c) => c['id'] as int)
          .toList();
      return ApiResult.success(castList);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }
}

