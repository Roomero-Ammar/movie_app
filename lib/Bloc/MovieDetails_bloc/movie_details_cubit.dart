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
    if (isClosed) return;  // تأكد من أن الـ Cubit لم يتم غلقه بعد

    emit(MovieDetailLoading());
    
    final result = await _movieRepository.fetchMovieDetail(movieId);

    if (isClosed) return;  // تأكد من أن الـ Cubit لم يتم غلقه بعد

    result.when(
      success: (movie) {
        if (!isClosed) emit(MovieDetailLoaded(movie));  // تأكد من عدم غلق الـ Cubit قبل التحديث
      },
      failure: (error) {
        if (!isClosed) emit(MovieDetailError(NetworkExceptions.getDioException(error).toString()));
      },
    );
  }
}
