part of 'genre_cubit.dart';


@immutable
abstract class GenreState {}

class GenreInitial extends GenreState {}

class GenreLoading extends GenreState {}

class GenreLoaded extends GenreState {
  final List<Genre> genres;
  GenreLoaded(this.genres);
}

class GenreError extends GenreState {
  final String error;
  GenreError(this.error);
}
