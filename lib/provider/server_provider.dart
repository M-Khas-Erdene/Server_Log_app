import 'package:flutter/material.dart';
import '../dio/ApiService.dart';
import '../components/server.dart';

class ServerProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  Server? _server;
  bool _isLoading = true;

  Server? get server => _server;
  bool get isLoading => _isLoading;

  Future<void> fetchServerDetails(int serverId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _server = await apiService.fetchServerDetails(serverId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateServerDetails(
      int serverId, Map<String, dynamic> data) async {
    await apiService.updateServerDetails(serverId, data);
    await fetchServerDetails(serverId);
  }
}
