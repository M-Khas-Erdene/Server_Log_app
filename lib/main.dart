import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/server.dart';
import 'pages/login_screen.dart';
import 'pages/history_page.dart';
import 'provider/server_provider.dart';
import 'provider/server_list_provider.dart';
import 'pages/list_server.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServerProvider()),
        ChangeNotifierProvider(create: (_) => ServerListProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    setState(() {
      _isAuthenticated = token != null;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return MaterialApp(
        title: 'My Flutter App',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        supportedLocales: const <Locale>[Locale('en', 'US')],
        debugShowCheckedModeBanner: true,
        home: LoginScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/servers': (context) => const ListServer(),
          '/history/servers': (context) => HistoryScreen(),
        },
      );
    }

    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      supportedLocales: const <Locale>[Locale('en', 'US')],
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ML SERVERS'),
          backgroundColor: const Color.fromARGB(208, 157, 0, 255),
          actions: <Widget>[
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: Color.fromARGB(211, 255, 255, 255),
                  ),
                  tooltip: 'Log out',
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove('token');
                    setState(() {
                      _isAuthenticated = false;
                    });
                  },
                );
              },
            ),
          ],
        ),
        body: _selectedIndex == 0 ? const ListServer() : HistoryScreen(),
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
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/servers': (context) => const ListServer(),
        '/history/servers': (context) => HistoryScreen(),
      },
    );
  }
}
