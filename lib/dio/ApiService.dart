import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/server.dart';
import '../components/history.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:5000'));
  Future<List<Server>> fetchServers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await _dio.get(
        '/servers',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      List jsonResponse = response.data;
      return jsonResponse.map((server) => Server.fromJson(server)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load servers: ${e.response?.statusCode}');
    }
  }

  Future<List<History>> fetchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await _dio.get(
        '/history/servers',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      List jsonResponse = response.data;
      return jsonResponse.map((history) => History.fromJson(history)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load history: ${e.response?.statusCode}');
    }
  }

  Future<Server> fetchServerDetails(int serverId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await _dio.get(
        '/servers/$serverId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return Server.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          'Failed to load server details: ${e.response?.statusCode}');
    }
  }

  Future<void> updateServerDetails(
      int serverId, Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      await _dio.put(
        '/servers/date/$serverId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: data,
      );
    } on DioException catch (e) {
      throw Exception('Failed to update server: ${e.response?.statusCode}');
    }
  }

  Future<String?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: {
          'loginData': {
            'username': username,
            'password': password,
          },
        },
      );

      if (response.statusCode == 200) {
        return response.data['token'];
      } else {
        throw Exception(response.data['error'] ?? 'Unknown error occurred');
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['error'] ?? 'An unexpected error occurred');
    }
  }
}
