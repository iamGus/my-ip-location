import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient({Dio? dio}) : dio = dio ?? Dio();

  // Get request
  Future<Response> get(String path) async {
    try {
      final response = await dio.get(path);
      return response;
    } on DioException catch (e) {
      print('Error: ${e.message}');
      throw e;
    }
  }
}
