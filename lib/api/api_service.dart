import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quizzie/api/user_data_storage_service.dart';

class ApiService {
  final Dio _dio = Dio();
  ApiService(){
    _dio.options.baseUrl = dotenv.env['BASE_API_URL']!;
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await UserDataStorageService().get("token");
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        return handler.next(error);
      },
    ));
  }

  Future<Response> get(String endpoint) async {
    return _dio.get(endpoint);
  }

  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    return _dio.post(endpoint, data: data);
  }
}