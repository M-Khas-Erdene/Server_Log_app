import 'package:flutter/material.dart';
import '../dio/ApiService.dart';
import '../components/server.dart';

class ServerProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  Server? server;
  bool isLoading = true;

  Future<void> fetchServerDetails(int serverId) async {
    isLoading = true;
    notifyListeners();

    try {
      server = await _apiService.fetchServerDetails(serverId);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      throw Exception('Failed to load server details: $e');
    }
  }

  void updateServerStatus(Server updatedServer) {
    server = updatedServer;
    notifyListeners();
  }
}
