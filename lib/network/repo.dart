import 'package:movie_app/models/movie/movie.dart';

import 'api_result.dart';
import 'api_service.dart';
import 'network_exceptions.dart';

class MovieRepository {
  final ApiService _apiService;

  MovieRepository(this._apiService);

  Future<ApiResult<List<Movie>>> fetchNowPlayingMovies() async {
    try {
      final response = await _apiService.get('/movie/now_playing');
      final movies = (response.data['results'] as List)
          .map((m) => Movie.fromJson(m))
          .toList();
      return ApiResult.success(movies);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<List<Movie>>> fetchMoviesByGenre(int genreId) async {
    try {
      final response = await _apiService
          .get('/discover/movie', params: {'with_genres': genreId});
      final movies = (response.data['results'] as List)
          .map((m) => Movie.fromJson(m))
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
    // جلب تفاصيل الفيلم
    final response = await _apiService.get('/movie/$movieId');
    final movie = Movie.fromJson(response.data);

    // جلب التفاصيل الإضافية
    final youtubeIdResult = await fetchYoutubeId(movieId);
    final imagePathResult = await fetchMovieImage(movieId);
    final castListResult = await fetchCastList(movieId);

    // التحقق من أي من نتائج API لم تنجح
    if (youtubeIdResult is Failure ||
        imagePathResult is Failure ||
        castListResult is Failure) {
      return ApiResult.failure(
          NetworkExceptions.getDioException("فشل في جلب تفاصيل الفيلم"));
    }

    // إذا كانت التفاصيل موجودة، قم بتحديث خصائص الفيلم
    movie.trailer = (youtubeIdResult as Success<YoutubeVideo>).data;
    movie.movieImage = (imagePathResult as Success<MovieImage>).data;
    movie.cast = (castListResult as Success<List<Cast>>).data;

    return ApiResult.success(movie);
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
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
