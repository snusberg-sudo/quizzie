import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quizzie/data/providers/user_data_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String? token;
  final Dio _dio = Dio();
  bool _initialized = false;

  Future<String?> retrieveIp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("ip");
  }

  ApiService({required this.token}) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await _ensureInitialized();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      final ip = await retrieveIp();
      final baseUrl = 'http://$ip/api';
      _dio.options.baseUrl = baseUrl;
      _initialized = true;
    }
  }

  Future<Response> get(String endpoint) async {
    await _ensureInitialized();
    return _dio.get(endpoint);
  }

  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    await _ensureInitialized();
    return _dio.post(endpoint, data: data);
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  final token = ref.watch(userDataProvider).user?.token;
  return ApiService(token: token);
});
