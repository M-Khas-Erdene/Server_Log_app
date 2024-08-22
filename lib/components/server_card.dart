import 'package:flutter/material.dart';
import '../components/server.dart';
import '../components/server_detail.dart';
import 'package:provider/provider.dart';
import '../provider/server_provider.dart';

class ServerCard extends StatelessWidget {
  final Server server;
  final Future<void> Function() onUpdate;

  const ServerCard({Key? key, required this.server, required this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isActive = server.status.toLowerCase() == 'active';
    String serverIMG = 'assets/serverIMG.jpg';

    return GestureDetector(
      onTap: () async {
        bool? shouldRefresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context) =>
                  ServerProvider()..fetchServerDetails(server.id),
              child: ServerDetail(serverId: server.id),
            ),
          ),
        );
        if (shouldRefresh == true) {
          onUpdate();
        }
      },
      child: Card(
        elevation: 5,
        shadowColor: Colors.black,
        color: isActive ? Colors.greenAccent[100] : Colors.redAccent[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    child: Image.asset(
                      serverIMG,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(height: 5),
                        Text(
                          server.serverName,
                          style: TextStyle(
                            fontSize: 24,
                            color:
                                isActive ? Colors.green[900] : Colors.red[900],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(height: 5),
                        Text(
                          'Location: ${server.location}',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                isActive ? Colors.green[700] : Colors.red[700],
                          ),
                        ),
                        Container(height: 10),
                        Text(
                          'System: ${server.systemRunning}',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                isActive ? Colors.green[700] : Colors.red[700],
                          ),
                        ),
                        Container(height: 10),
                        Text(
                          'Reason for failure: ${server.reasonForFailure}',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                isActive ? Colors.green[700] : Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
