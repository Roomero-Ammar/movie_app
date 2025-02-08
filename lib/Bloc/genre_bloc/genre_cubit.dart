import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_app/models/movie/movie.dart';
import 'package:movie_app/network/network_exceptions.dart';
import 'package:movie_app/network/repo.dart';

part 'genre_state.dart';

class GenreCubit extends Cubit<GenreState> {
  final MovieRepository _movieRepository;

 // GenreCubit(this._movieRepository) : super(GenreInitial());
  
  GenreCubit(this._movieRepository) : super(GenreInitial()) {
    // Fetch trending persons when the cubit is initialized
    fetchGenres();
  }

  Future<void> fetchGenres() async {
    emit(GenreLoading());
    final result = await _movieRepository.fetchGenres();

    result.when(
      success: (genres) {
        emit(GenreLoaded(genres));
      },
      failure: (error) {
        emit(GenreError(NetworkExceptions.getDioException(error).toString()));
      },
    );
  }
}
