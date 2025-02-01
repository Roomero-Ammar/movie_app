import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_app/models/movie/movie.dart';
import 'package:movie_app/network/network_exceptions.dart';
import 'package:movie_app/network/repo.dart';

part 'movie_details_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final MovieRepository _movieRepository;

  MovieDetailCubit(this._movieRepository) : super(MovieDetailInitial());

  Future<void> fetchMovieDetail(int movieId) async {
    emit(MovieDetailLoading());
    final result = await _movieRepository.fetchMovieDetail(movieId);

    result.when(
      success: (movie) {
        emit(MovieDetailLoaded(movie));
      },
      failure: (error) {
        emit(MovieDetailError(NetworkExceptions.getDioException(error).toString()));
      },
    );
  }
}
