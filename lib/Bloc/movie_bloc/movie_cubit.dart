import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_app/models/movie/movie.dart';
import 'package:movie_app/network/network_exceptions.dart';
import 'package:movie_app/network/repo.dart';


part 'movie_state.dart';


class MovieCubit extends Cubit<MovieState> {
  final MovieRepository _movieRepository;

  MovieCubit(this._movieRepository) : super(MovieInitial());

  Future<void> fetchNowPlayingMovies() async {
    emit(MovieLoading());
    final result = await _movieRepository.fetchNowPlayingMovies();

    // استخدام when هنا
    result.when(
      success: (movies) {
        emit(MovieLoaded(movies));
      },
      failure: (error) {
        emit(MovieError(NetworkExceptions.getDioException.toString())); // تأكد من أن لديك طريقة للوصول إلى الرسالة
      },
    );
  }
}