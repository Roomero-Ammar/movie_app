import 'package:dio/dio.dart';
import 'package:movie_app/constants/strings.dart';
import 'package:movie_app/network/api_result.dart';
import 'package:movie_app/network/network_exceptions.dart';

class ApiService {
  final Dio dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    queryParameters: {'api_key': apiKey},
  ));

  Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      return await dio.get(endpoint, queryParameters: params);
    } catch (error) {
      throw ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }
}