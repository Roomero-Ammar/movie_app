import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/Bloc/MovieDetails_bloc/movie_details_cubit.dart';
import 'package:movie_app/Bloc/movie_bloc/movie_cubit.dart';
import 'package:movie_app/Bloc/genre_bloc/genre_cubit.dart';
import 'package:movie_app/Bloc/person_bloc/person_cubit.dart';
import 'package:movie_app/network/api_service.dart';
import 'package:movie_app/network/repo.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // 1️⃣ تسجيل Dio
  getIt.registerLazySingleton<Dio>(() => createAndSetupDio());

  // 2️⃣ تسجيل ApiService (يعتمد على Dio)
  getIt.registerLazySingleton<ApiService>(() => ApiService());

  // 3️⃣ تسجيل Repository (يعتمد على ApiService)
  getIt.registerLazySingleton<MovieRepository>(() => MovieRepository(getIt<ApiService>()));

  // 4️⃣ تسجيل Cubits (كل Cubit يأخذ الـ Repository الخاص به)
  getIt.registerLazySingleton<MovieCubit>(() => MovieCubit(getIt<MovieRepository>()));
  getIt.registerLazySingleton<GenreCubit>(() => GenreCubit(getIt<MovieRepository>()));
  getIt.registerLazySingleton<PersonCubit>(() => PersonCubit(getIt<MovieRepository>()));
  getIt.registerLazySingleton<MovieDetailCubit>(() => MovieDetailCubit(getIt<MovieRepository>()));
}

// 🔹 إعداد Dio مع Interceptors لتسجيل الطلبات والاستجابات
Dio createAndSetupDio() {
  Dio dio = Dio();

  dio
    ..options.connectTimeout = const Duration(seconds: 100)
    ..options.receiveTimeout = const Duration(seconds: 100);

  dio.interceptors.add(LogInterceptor(
    responseBody: true, 
    error: true,  
    request: true,   
    requestBody: true,  
    requestHeader: true,
    responseHeader: true, 
  ));

  return dio;
}
