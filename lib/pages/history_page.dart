import 'package:flutter/material.dart';
import '../ApiService.dart';
import '../components/history.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<History>> futureHistory;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureHistory = apiService.fetchHistory();
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<History>>(
          future: futureHistory,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final history = snapshot.data![index];

                  Color backgroundColor;
                  if (history.dateOfFailure != null &&
                      history.dateOfStartup != null) {
                    if (history.dateOfFailure!
                        .isAfter(history.dateOfStartup!)) {
                      backgroundColor = Colors.redAccent[100]!;
                    } else {
                      backgroundColor = Colors.greenAccent[100]!;
                    }
                  } else {
                    backgroundColor = Colors.grey[200]!;
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      color: backgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'User: ${history.username}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Server Name: ${history.serverName}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Reason for Failure: ${history.reasonForFailure}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Date of Failure: ${formatDateTime(history.dateOfFailure?.toLocal())}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Date of Startup: ${formatDateTime(history.dateOfStartup?.toLocal())}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Change Timestamp: ${formatDateTime(history.change_timestamp?.toLocal())}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Status: ${history.status}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Text('No history available');
            }
          },
        ),
      ),
    );
  }
}
