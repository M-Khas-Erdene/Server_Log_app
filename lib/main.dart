import 'package:flutter/material.dart';

import 'components/server.dart';
import 'pages/login_screen.dart';
import 'components/server_detail.dart';
import 'pages/history_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dio/ApiService.dart';
import 'components/history.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/servers': (context) => const ListServer(),
        '/history/servers': (context) => HistoryScreen(),
      },
      title: 'My Flutter App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      supportedLocales: const <Locale>[Locale('en', 'US')],
      debugShowCheckedModeBanner: true,
    );
  }
}

class ListServer extends StatefulWidget {
  const ListServer({Key? key}) : super(key: key);

  @override
  _ListServerState createState() => _ListServerState();
}

class _ListServerState extends State<ListServer> {
  late Future<List<Server>> futureServers;
  late Future<List<History>> futureHistory;
  int _selectedIndex = 0;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchServers();
    futureHistory = apiService.fetchHistory();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchServers();
  }

  void _fetchServers() {
    setState(() {
      futureServers = apiService.fetchServers();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _refreshServers() async {
    _fetchServers();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_selectedIndex == 0) {
      body = RefreshIndicator(
        onRefresh: _refreshServers,
        child: Center(
          child: FutureBuilder<List<Server>>(
            future: futureServers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ServerCard(
                      server: snapshot.data![index],
                      onUpdate: _refreshServers,
                    );
                  },
                );
              } else {
                return const Text('No servers available');
              }
            },
          ),
        ),
      );
    } else {
      body = HistoryScreen();
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        title: const Text(
          "ML SERVERS",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Color.fromARGB(211, 255, 255, 255),
            ),
            tooltip: 'Log out',
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
        backgroundColor: const Color.fromARGB(208, 157, 0, 255),
        elevation: 50.0,
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        fixedColor: Colors.green,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "History",
            icon: Icon(Icons.search),
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}

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
            builder: (context) => ServerDetail(
              serverId: server.id,
              onUpdate: onUpdate,
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
