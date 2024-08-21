import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'components/server.dart';
import 'components/history.dart';

class ApiService {
  Future<List<Server>> fetchServers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/servers'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((server) => Server.fromJson(server)).toList();
    } else {
      throw Exception('Failed to load servers');
    }
  }

  Future<List<History>> fetchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/history/servers'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((history) => History.fromJson(history)).toList();
    } else {
      throw Exception('Failed to load servers');
    }
  }
}
