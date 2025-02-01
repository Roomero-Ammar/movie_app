part of 'movie_details_cubit.dart';

@immutable
abstract class MovieDetailState {}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final Movie movie;
  MovieDetailLoaded(this.movie);
}

class MovieDetailError extends MovieDetailState {
  final String error;
  MovieDetailError(this.error);
}
