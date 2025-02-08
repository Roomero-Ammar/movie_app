import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_app/models/movie/movie.dart';
import 'package:movie_app/network/network_exceptions.dart';
import 'package:movie_app/network/repo.dart';

part 'person_state.dart';

class PersonCubit extends Cubit<PersonState> {
  final MovieRepository _movieRepository;

//  PersonCubit(this._movieRepository) : super(PersonInitial());

PersonCubit(this._movieRepository) : super(PersonInitial()) {
    // Fetch trending persons when the cubit is initialized
    fetchTrendingPersons();
  }

  Future<void> fetchTrendingPersons() async {
    emit(PersonLoading());
    final result = await _movieRepository.fetchTrendingPersons();

    result.when(
      success: (persons) {
        emit(PersonLoaded(persons));
      },
      failure: (error) {
        emit(PersonError(NetworkExceptions.getDioException(error).toString()));
      },
    );
  }
}
