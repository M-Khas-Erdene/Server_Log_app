import 'package:flutter/material.dart';
import '../components/server.dart';
import '../dio/ApiService.dart';

class ServerListProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  List<Server>? _servers;
  bool _isLoading = true;
  String? _error;

  List<Server>? get servers => _servers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchServers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _servers = await apiService.fetchServers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshServers() async {
    await fetchServers();
  }
}
