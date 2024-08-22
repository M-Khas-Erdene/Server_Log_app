import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../pages/edit_server_page.dart';
import 'package:provider/provider.dart';
import '../provider/server_provider.dart';

class ServerDetail extends StatelessWidget {
  final int serverId;

  const ServerDetail({Key? key, required this.serverId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serverProvider = Provider.of<ServerProvider>(context);

    if (serverProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    String formatDateTime(DateTime? dateTime) {
      if (dateTime == null) return '';
      final dateTimeWithOffset = dateTime.add(const Duration(hours: 8));
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTimeWithOffset);
    }

    final server = serverProvider.server!;
    bool isActive = server.status.toLowerCase() == 'active';

    return Scaffold(
      backgroundColor:
          isActive ? Colors.greenAccent[100] : Colors.redAccent[100],
      appBar: AppBar(
        title: Text(server.serverName),
        backgroundColor:
            isActive ? Colors.greenAccent[400] : Colors.redAccent[400],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/serverIMG.jpg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              'Location: ${server.location}',
              style: TextStyle(
                fontSize: 18,
                color: isActive ? Colors.green[700] : Colors.red[700],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'System Running: ${server.systemRunning}',
              style: TextStyle(
                fontSize: 18,
                color: isActive ? Colors.green[700] : Colors.red[700],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Internal Address: ${server.internalAddress}',
              style: TextStyle(
                fontSize: 18,
                color: isActive ? Colors.green[700] : Colors.red[700],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'External Address: ${server.externalAddress}',
              style: TextStyle(
                fontSize: 18,
                color: isActive ? Colors.green[700] : Colors.red[700],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Reason for Failure: ${server.reasonForFailure}',
              style: TextStyle(
                fontSize: 18,
                color: isActive ? Colors.green[700] : Colors.red[700],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Date of Failure: ${formatDateTime(server.dateOfFailure)}',
              style: TextStyle(
                fontSize: 18,
                color: isActive ? Colors.green[700] : Colors.red[700],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Date of Startup: ${formatDateTime(server.dateOfStartup)}',
              style: TextStyle(
                fontSize: 18,
                color: isActive ? Colors.green[700] : Colors.red[700],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Status: ${server.status}',
              style: TextStyle(
                fontSize: 18,
                color: isActive ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final bool? shouldRefresh = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditServerPage(server: server),
                    ),
                  );

                  if (shouldRefresh ?? false) {
                    await serverProvider.fetchServerDetails(serverId);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  backgroundColor: isActive ? Colors.green : Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Change State',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
