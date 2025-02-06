import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_app/models/movie/movie.dart';
import 'package:movie_app/network/network_exceptions.dart';
import 'package:movie_app/network/repo.dart';


part 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieRepository _movieRepository;

  // لتخزين حالة الفلترة أو النوع
  int? selectedGenreId;

  MovieCubit(this._movieRepository) : super(MovieInitial()) {
    // تحميل الأفلام المعروضة حاليًا عند البداية
    fetchNowPlayingMovies();
  }

  // دالة لتحميل الأفلام المعروضة حاليًا
  Future<void> fetchNowPlayingMovies() async {
    emit(MovieLoading());  // يظهر مؤشر التحميل

    // إذا كان هناك نوع محدد، قم بتحميل الأفلام حسب النوع
    if (selectedGenreId != null) {
      await fetchMoviesByGenre(selectedGenreId!); // تحميل الأفلام حسب النوع
    } else {
      // إذا لم يتم تحديد نوع، قم بتحميل الأفلام العامة (المعروضة حاليًا)
      final result = await _movieRepository.fetchNowPlayingMovies();
      result.when(
        success: (movies) {
          emit(MovieLoaded(movies));  // عرض الأفلام
        },
        failure: (error) {
          emit(MovieError(NetworkExceptions.getDioException(error).toString()));  // عرض الخطأ
        },
      );
    }
  }

  // دالة لتحميل الأفلام حسب النوع
  Future<void> fetchMoviesByGenre(int genreId) async {
    emit(MovieLoading());  // يظهر مؤشر التحميل

    selectedGenreId = genreId;  // حفظ النوع المحدد

    // تحميل الأفلام حسب النوع
    final result = await _movieRepository.fetchMoviesByGenre(genreId);
    result.when(
      success: (movies) {
        emit(MovieLoaded(movies));  // عرض الأفلام
      },
      failure: (error) {
        emit(MovieError(NetworkExceptions.getDioException(error).toString()));  // عرض الخطأ
      },
    );
  }
}
